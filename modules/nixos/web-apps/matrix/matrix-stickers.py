import argparse
import asyncio
import json
import os
import re
import shutil
import sys
from pathlib import Path
from urllib.parse import quote

import aiohttp
from sticker.download_thumbnails import main as download_thumbnails
from sticker.lib import matrix, util

STATE_DIR = Path("/var/lib/matrix-stickers")
PRIVATE_DIR = STATE_DIR / "private"
PACKS_DIR = STATE_DIR / "packs"
CONFIG_PATH = PRIVATE_DIR / "config.json"
PICKER_URL = os.environ["MATRIX_STICKER_PICKER_URL"]
SOURCE_DIR = Path(os.environ["STICKERPICKER_SOURCE"])


def ensure_layout() -> None:
    PRIVATE_DIR.mkdir(mode=0o700, parents=True, exist_ok=True)
    PACKS_DIR.mkdir(mode=0o755, parents=True, exist_ok=True)


async def load_config() -> dict:
    ensure_layout()
    await matrix.load_config(str(CONFIG_PATH))
    CONFIG_PATH.chmod(0o600)
    with CONFIG_PATH.open() as config_file:
        return json.load(config_file)


async def request(
    config: dict,
    method: str,
    path: str,
    payload: dict | None = None,
    allow_missing: bool = False,
) -> dict | None:
    headers = {"Authorization": f"Bearer {config['access_token']}"}
    url = f"{config['homeserver'].rstrip('/')}{path}"
    async with aiohttp.ClientSession(headers=headers) as session:
        async with session.request(method, url, json=payload) as response:
            if allow_missing and response.status == 404:
                return None
            if response.status >= 400:
                body = await response.text()
                raise RuntimeError(f"Matrix request failed ({response.status}): {body}")
            if response.content_length == 0:
                return {}
            return await response.json()


async def import_scalar_packs(names: list[str]) -> None:
    await load_config()
    available = {path.stem: path for path in (SOURCE_DIR / "packs").glob("*.json")}
    if not names:
        names = sorted(available)

    for name in names:
        name = name if name.startswith("scalar-") else f"scalar-{name}"
        try:
            source_path = available[name]
        except KeyError as error:
            choices = ", ".join(
                key.removeprefix("scalar-") for key in sorted(available)
            )
            raise RuntimeError(
                f"Unknown Scalar pack {name!r}; available packs: {choices}"
            ) from error

        destination = PACKS_DIR / source_path.name
        shutil.copyfile(source_path, destination)
        await download_thumbnails(
            argparse.Namespace(config=str(CONFIG_PATH), path=str(destination))
        )
        util.add_to_index(destination.name, str(PACKS_DIR))


async def enable_picker() -> None:
    config = await load_config()
    user_id = config["user_id"]
    path = f"/_matrix/client/v3/user/{quote(user_id, safe='')}/account_data/m.widgets"
    widgets = await request(config, "GET", path, allow_missing=True) or {}
    widgets = {
        widget_id: widget
        for widget_id, widget in widgets.items()
        if widget.get("content", {}).get("type") != "m.stickerpicker"
    }
    widgets["stickerpicker"] = {
        "content": {
            "type": "m.stickerpicker",
            "url": PICKER_URL,
            "name": "Stickerpicker",
            "creatorUserId": user_id,
            "data": {},
        },
        "sender": user_id,
        "state_key": "stickerpicker",
        "type": "m.widget",
        "id": "stickerpicker",
    }
    await request(config, "PUT", path, widgets)
    print(f"Enabled {PICKER_URL} for {user_id}")


def make_shortcode(sticker: dict, index: int, used: set[str]) -> str:
    source = sticker.get("body") or sticker.get("id") or f"sticker_{index}"
    shortcode = re.sub(r"[^A-Za-z0-9_-]+", "_", source).strip("_-")
    if not shortcode:
        shortcode = f"sticker_{index}"
    shortcode = shortcode.encode("ascii")[:100].decode("ascii")
    candidate = shortcode
    suffix = 2
    while candidate in used:
        marker = f"_{suffix}"
        candidate = f"{shortcode[: 100 - len(marker)]}{marker}"
        suffix += 1
    used.add(candidate)
    return candidate


def convert_pack(pack: dict) -> dict:
    images = {}
    used = set()
    for index, sticker in enumerate(pack["stickers"], start=1):
        shortcode = make_shortcode(sticker, index, used)
        image = {"url": sticker["url"]}
        if sticker.get("body"):
            image["body"] = sticker["body"]
        if sticker.get("info"):
            image["info"] = sticker["info"]
        images[shortcode] = image
    return {
        "images": images,
        "pack": {
            "display_name": pack["title"],
            "usage": ["sticker"],
        },
    }


async def publish_pack(pack_path: Path, room_id: str, state_key: str | None) -> None:
    config = await load_config()
    with pack_path.open() as pack_file:
        legacy_pack = json.load(pack_file)
    state_key = state_key or legacy_pack["id"]
    image_pack = convert_pack(legacy_pack)
    encoded_room = quote(room_id, safe="")
    encoded_key = quote(state_key, safe="")

    # Matrix 1.19 introduced stable identifiers, while deployed clients may
    # still consume the former MSC2545 names.
    for event_type in ("m.room.image_pack", "im.ponies.room_emotes"):
        encoded_type = quote(event_type, safe="")
        path = (
            f"/_matrix/client/v3/rooms/{encoded_room}/state/"
            f"{encoded_type}/{encoded_key}"
        )
        await request(config, "PUT", path, image_pack)

    user_id = quote(config["user_id"], safe="")
    for account_type in ("m.image_pack.rooms", "im.ponies.emote_rooms"):
        encoded_type = quote(account_type, safe="")
        path = f"/_matrix/client/v3/user/{user_id}/account_data/{encoded_type}"
        account_data = await request(config, "GET", path, allow_missing=True) or {
            "rooms": {}
        }
        account_data.setdefault("rooms", {}).setdefault(room_id, {})[state_key] = {}
        await request(config, "PUT", path, account_data)

    print(
        f"Published {legacy_pack['title']} as {state_key} in {room_id} "
        "and enabled it globally"
    )


def run_upstream(module: str, arguments: list[str]) -> None:
    os.execv(sys.executable, [sys.executable, "-m", module, *arguments])


def main() -> None:
    parser = argparse.ArgumentParser(prog="matrix-stickers")
    subparsers = parser.add_subparsers(dest="command", required=True)

    local_parser = subparsers.add_parser("local")
    local_parser.add_argument("path")
    local_parser.add_argument("--title")
    local_parser.add_argument("--id")

    telegram_parser = subparsers.add_parser("telegram")
    telegram_parser.add_argument("packs", nargs="*")
    telegram_parser.add_argument("--list", action="store_true")

    scalar_parser = subparsers.add_parser("scalar")
    scalar_parser.add_argument("packs", nargs="*")

    subparsers.add_parser("enable")

    publish_parser = subparsers.add_parser("publish")
    publish_parser.add_argument("pack", type=Path)
    publish_parser.add_argument("room_id")
    publish_parser.add_argument("--state-key")

    args = parser.parse_args()
    ensure_layout()

    if args.command == "enable":
        asyncio.run(enable_picker())
    elif args.command == "scalar":
        asyncio.run(import_scalar_packs(args.packs))
    elif args.command == "publish":
        asyncio.run(publish_pack(args.pack, args.room_id, args.state_key))
    else:
        asyncio.run(load_config())
        if args.command == "local":
            arguments = [
                "--config",
                str(CONFIG_PATH),
                "--add-to-index",
                str(PACKS_DIR),
            ]
            if args.title:
                arguments.extend(["--title", args.title])
            if args.id:
                arguments.extend(["--id", args.id])
            arguments.append(args.path)
            run_upstream("sticker.pack", arguments)
        else:
            arguments = [
                "--config",
                str(CONFIG_PATH),
                "--session",
                str(PRIVATE_DIR / "telegram"),
                "--output-dir",
                str(PACKS_DIR),
            ]
            if args.list:
                arguments.append("--list")
            arguments.extend(args.packs)
            run_upstream("sticker.stickerimport", arguments)


if __name__ == "__main__":
    main()
