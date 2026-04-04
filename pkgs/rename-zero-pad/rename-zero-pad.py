#!/usr/bin/env -S uv run --script
# vim:ft=python

import argparse
import sys
from pathlib import Path
from collections import Counter
from datetime import datetime
import fnmatch


LOG_FILE = Path("./rename-zero-pad.log")


def log_skip(msg: str):
    timestamp = datetime.now().isoformat(timespec="seconds")
    line = f"[{timestamp}] {msg}\n"
    LOG_FILE.open("a", encoding="utf-8").write(line)


def parse_args():
    p = argparse.ArgumentParser(
        description="Rename files with zero-padded numeric names."
    )
    p.add_argument(
        "--ext", "-e",
        help="File extension without dot (auto-detect if omitted)",
    )
    p.add_argument(
        "--numeral",
        action="store_true",
        help="Sort by numeric part in filename",
    )
    p.add_argument(
        "--renumber",
        action="store_true",
        help="Renumber sequentially (1..N) after sorting",
    )
    p.add_argument(
        "--initial",
        type=int,
        default=1,
        metavar="NUM",
        help="Start renumbering sequence from NUM",
    )
    p.add_argument(
        "--pattern",
        help="Glob pattern to filter filenames (e.g. '*lecture*')",
    )
    p.add_argument(
        "--dry-run",
        action="store_true",
        help="Preview changes without renaming",
    )
    p.add_argument(
        "--recursive", "-r",
        action="store_true",
        help="Process directories recursively (each directory has its own counter)",
    )
    return p.parse_args()


def extract_number(stem: str) -> int | None:
    digits = "".join(ch for ch in stem if ch.isdigit())
    return int(digits) if digits else None


def auto_detect_ext(files: list[Path]) -> str | None:
    exts = [f.suffix.lstrip(".") for f in files if f.suffix]
    if not exts:
        return None

    counter = Counter(exts)
    if len(counter) == 1:
        return exts[0]

    return None


def collect_files(base: Path, recursive: bool) -> dict[Path, list[Path]]:
    result: dict[Path, list[Path]] = {}

    if recursive:
        for d in [base, *[p for p in base.rglob("*") if p.is_dir()]]:
            files = [f for f in d.iterdir() if f.is_file()]
            if files:
                result[d] = files
    else:
        files = [f for f in base.iterdir() if f.is_file()]
        if files:
            result[base] = files

    return result


def build_rename_plan(
    directory: Path,
    files: list[Path],
    ext: str,
    numeral: bool,
    renumber: bool,
    pattern: str | None,
    initial: int,
    display_dir: str = "",
):
    # ext 过滤
    files = [f for f in files if f.suffix.lstrip(".") == ext]

    # pattern 过滤
    if pattern:
        files = [f for f in files if fnmatch.fnmatch(f.name, pattern)]

    if not files:
        msg = f"[SKIP] {display_dir}: no matching *.{ext} files"
        print(msg)
        log_skip(msg)
        return []

    # 排序阶段
    if numeral:
        numbered = []
        for f in files:
            n = extract_number(f.stem)
            if n is None:
                msg = f"[SKIP] {display_dir}: no number in {f.name}"
                print(msg)
                log_skip(msg)
                continue
            numbered.append((n, f))

        if not numbered:
            msg = f"[SKIP] {display_dir}: no files contain numeric parts"
            print(msg)
            log_skip(msg)
            return []

        numbered.sort(key=lambda x: x[0])

        ordered_files = [f for _, f in numbered]
        numbers = [n for n, _ in numbered]
    else:
        ordered_files = sorted(files, key=lambda f: f.name)
        numbers = list(range(initial, initial + len(ordered_files)))

    cnt = len(ordered_files)
    max_number = max(numbers) if numbers else initial
    pad = len(str(max_number))

    plan = []

    if renumber:
        # 强制 initial..(initial+N-1)
        for i, f in enumerate(ordered_files, start=initial):
            new_name = f"{str(i).zfill(pad)}.{ext}"
            plan.append((f, f.with_name(new_name)))
    else:
        # 使用原始数字或默认序号
        for n, f in zip(numbers, ordered_files):
            new_name = f"{str(n).zfill(pad)}.{ext}"
            plan.append((f, f.with_name(new_name)))

    return plan


def main():
    args = parse_args()
    base = Path.cwd()

    dir_map = collect_files(base, args.recursive)
    if not dir_map:
        print("No files found.")
        return 0

    full_plan: list[tuple[Path, Path]] = []

    for directory, files in dir_map.items():
        display_dir = str(directory.relative_to(base)) if args.recursive else "."
        ext = args.ext
        if ext is None:
            ext = auto_detect_ext(files)
            if ext is None:
                msg = f"[SKIP] {display_dir}: cannot auto-detect unique extension"
                print(msg)
                log_skip(msg)
                continue

        plan = build_rename_plan(
            directory=directory,
            files=files,
            ext=ext,
            numeral=args.numeral,
            renumber=args.renumber,
            pattern=args.pattern,
            initial=args.initial,
            display_dir=display_dir,
        )

        full_plan.extend(plan)

    if not full_plan:
        print("Nothing to rename.")
        return 0

    # 全局冲突检测
    targets = [dst for _, dst in full_plan]
    if len(targets) != len(set(targets)):
        print("Name collision detected, aborting.")
        return 2

    # 执行 / 预演
    for src, dst in full_plan:
        if src == dst:
            continue
        src_display = src.relative_to(base) if args.recursive else src.name
        dst_display = dst.relative_to(base) if args.recursive else dst.name
        if args.dry_run:
            print(f"[DRY] {src_display} -> {dst_display}")
        else:
            print(f"{src_display} -> {dst_display}")
            src.rename(dst)

    return 0


if __name__ == "__main__":
    sys.exit(main())
