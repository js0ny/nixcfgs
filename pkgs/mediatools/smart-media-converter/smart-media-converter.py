#!/usr/bin/env -S uv run --script
# vim:ft=python
# $SCRIPTS/smart-media-converter
# Date: 2025-12-03
# Author: js0ny
# Requires: fd ffmpeg imagemagick python >= 3.10
# Notes: Recursively searches media via 'fd' and converts them using ThreadPoolExecutor.
##########
# Flags:
#   --debug(-d): Enable debug logging
#   --dry-run(-n): Print actions without executing
#   --rm: Remove source file after SUCCESSFUL conversion
#   --dir: Target directory (default: current directory)
#   --workers(-j): Number of parallel workers (default: 3)
#   --video-container: Video output container format mp4 | mkv (default: mp4)
#   --picture-quality: Image quality for magick (default: 85)
#   --picture-format: Image output format for magick (default: webp)
##########

import sys
import logging
import argparse
import subprocess
import shutil
import threading
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import List, Tuple, Optional

# Configuration Constants
VIDEO_CRF = "32"
VIDEO_PRESET = "8"

# Extensions Configuration (Normalized to lowercase)
# Do not consider .avif and .webp as input extensions
IMG_EXTS = {".jpg", ".jpeg", ".png", ".tiff", ".bmp"}
VID_EXTS = {".mp4", ".mkv", ".mov", ".avi", ".webm", ".mts"}

# Thread-safe print lock for progress output
_print_lock = threading.Lock()

# Setup Logging
logger = logging.getLogger("MediaConverter")
handler = logging.StreamHandler(sys.stdout)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s', datefmt='%H:%M:%S')
handler.setFormatter(formatter)
logger.addHandler(handler)

def parse_size_human_readable(size: float) -> str:
    """Converts bytes into a human-readable string."""
    for unit in ['B', 'KB', 'MB', 'GB', 'TB']:
        if size < 1024:
            return f"{size:.2f}{unit}"
        size /= 1024
    return f"{size:.2f}PB"

def get_video_duration(file_path: Path) -> Optional[float]:
    """Gets video duration in seconds using ffprobe. Returns None on failure."""
    try:
        result = subprocess.run(
            ["ffprobe", "-v", "error", "-show_entries", "format=duration",
             "-of", "default=noprint_wrappers=1:nokey=1", str(file_path)],
            capture_output=True, text=True, timeout=30
        )
        return float(result.stdout.strip())
    except (subprocess.CalledProcessError, ValueError, subprocess.TimeoutExpired):
        return None

def run_video_command(cmd: List[str], dry_run: bool, file_path: Path, output_path: Path,
                      remove_source: bool, duration: Optional[float]) -> bool:
    """Runs ffmpeg with real-time progress bar for video conversion."""
    cmd_str_list = [str(c) for c in cmd]
    cmd_display = " ".join(f'"{c}"' if " " in c else c for c in cmd_str_list)

    if dry_run:
        logger.info(f"[DRY-RUN] {cmd_display}")
        return True

    logger.debug(f"Executing: {cmd_display}")

    src_size = file_path.stat().st_size
    src_label = parse_size_human_readable(src_size)
    name = file_path.name
    # Truncate long filenames for clean progress lines
    display_name = name if len(name) <= 40 else name[:37] + "..."

    try:
        proc = subprocess.Popen(
            cmd_str_list,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            stdin=subprocess.DEVNULL,
            universal_newlines=True,
            bufsize=1,
        )

        duration_us = int(duration * 1_000_000) if duration and duration > 0 else 0

        for line in proc.stdout:
            line = line.strip()
            if not line or '=' not in line:
                continue
            key, _, value = line.partition('=')

            if key == "out_time_us" and duration_us > 0:
                try:
                    out_us = int(value)
                except ValueError:
                    continue
                pct = max(0, min(100, (out_us / duration_us) * 100))
                # Check current output file size
                try:
                    out_size = output_path.stat().st_size
                except (FileNotFoundError, OSError):
                    out_size = 0
                out_label = parse_size_human_readable(out_size)

                with _print_lock:
                    sys.stdout.write(f"\r\033[K[VID] {display_name}  {pct:.0f}%  {out_label} / {src_label}")
                    sys.stdout.flush()

        proc.wait()

        if proc.returncode != 0:
            stderr_out = proc.stderr.read()
            with _print_lock:
                sys.stdout.write(f"\r\033[K")
                sys.stdout.flush()
            logger.error(f"Command failed: {cmd_display}")
            if stderr_out:
                err_lines = stderr_out.strip().split('\n')
                logger.error(f"Stderr: {err_lines[-1] if err_lines else 'Unknown error'}")
            return False

        # Conversion succeeded — print final line (no percentage)
        if output_path.exists():
            out_size = output_path.stat().st_size
            out_label = parse_size_human_readable(out_size)

            with _print_lock:
                sys.stdout.write(f"\r\033[K[VID] {display_name}  {out_label} / {src_label}\n")
                sys.stdout.flush()

            if out_size >= src_size:
                logger.warning(f"[BLOAT] Output is larger ({out_size} > {src_size}).")

            if remove_source:
                safe_remove(file_path, output_path, dry_run)

        return True

    except Exception as e:
        with _print_lock:
            sys.stdout.write(f"\r\033[K")
            sys.stdout.flush()
        logger.error(f"Video conversion error for {file_path.name}: {e}")
        return False

def check_dependencies():
    """Checks if required external tools are available."""
    missing = []
    for tool in ["fd", "ffmpeg", "magick"]:
        if not shutil.which(tool):
            missing.append(tool)
    if missing:
        logger.error(f"Missing required dependencies: {', '.join(missing)}")
        sys.exit(1)

def run_command(cmd: List[str], dry_run: bool, file_path: Path, output_path: Path, remove_source: bool) -> bool:
    """Executes a shell command safely."""
    cmd_str_list = [str(c) for c in cmd]
    cmd_display = " ".join(f'"{c}"' if " " in c else c for c in cmd_str_list)

    if dry_run:
        logger.info(f"[DRY-RUN] {cmd_display}")
        return True

    logger.debug(f"Executing: {cmd_display}")
    try:
        capture = logger.level != logging.DEBUG
        subprocess.run(
            cmd_str_list,
            check=True,
            stdout=subprocess.DEVNULL if capture else None,
            stderr=subprocess.PIPE if capture else None,
            stdin=subprocess.DEVNULL, # Important for parallel ffmpeg
            text=True
        )

        if not dry_run and output_path.exists():
            src_size = file_path.stat().st_size
            out_size = output_path.stat().st_size

            # 如果体积变大 (或者几乎没变小，比如只小了 1%)，则回滚
            if out_size >= src_size:
                logger.warning(f"[BLOAT] Output is larger ({out_size} > {src_size}).")# " Discarding AV1.")
            # elif remove_source:

            if remove_source:
                safe_remove(file_path, output_path, dry_run)

        return True
    except subprocess.CalledProcessError as e:
        logger.error(f"Command failed: {cmd_display}")
        if e.stderr:
            err_lines = e.stderr.strip().split('\n')
            logger.error(f"Stderr: {err_lines[-1] if err_lines else 'Unknown error'}")
        return False

def safe_remove(source: Path, output: Path, dry_run: bool):
    """Safely removes source file after verifying output."""
    if dry_run:
        logger.info(f"[DRY-RUN] rm \"{source}\"")
        return

    # DOUBLE CHECK: verify output exists and has content
    if not output.exists() or output.stat().st_size == 0:
        logger.critical(f"SAFETY ABORT: Output file {output} is missing or empty! Keeping source.")
        return

    try:
        source.unlink()
        logger.info(f"[RM] Deleted source: {source.name}")
    except OSError as e:
        logger.error(f"Failed to delete source {source}: {e}")

def convert_image(file_path: Path, dry_run: bool, remove_source: bool, picture_quality: int, picture_format: str) -> None:
    """Converts image to configured format and quality."""
    try:
        size = file_path.stat().st_size
    except FileNotFoundError:
        return

    ext = f".{picture_format.lower()}"

    label = parse_size_human_readable(size)

    output_path = file_path.with_suffix(ext)

    if output_path.exists():
        logger.info(f"[SKIP] Exists: {output_path.name}")
        # Logic decision: If output exists, do we delete source if --rm is on?
        # Safer to NOT delete automatically if we didn't just convert it.
        # User should verify manually.
        return

    logger.info(f"[{label}] {file_path.name} -> {ext}")

    cmd = ["magick", str(file_path), "-quality", str(picture_quality), str(output_path)]
    run_command(cmd, dry_run, file_path, output_path, remove_source)

def convert_video(file_path: Path, dry_run: bool, remove_source: bool, video_container: str) -> None:
    """Converts video to AV1 with progress tracking."""
    output_ext = f".av1.{video_container}"

    if file_path.name.endswith(output_ext):
        return

    output_path = file_path.with_suffix(output_ext)

    if output_path.exists():
        logger.info(f"[SKIP] Exists: {output_path.name}")
        return

    duration = get_video_duration(file_path)
    if duration is None:
        logger.warning(f"[VID] Could not probe duration for {file_path.name}, no progress bar")

    logger.info(f"[VID] {file_path.name} -> AV1")

    cmd = [
        "ffmpeg", "-hide_banner", "-loglevel", "error",
        "-progress", "pipe:1",
        "-i", str(file_path),
        "-c:v", "libsvtav1", "-crf", VIDEO_CRF, "-preset", VIDEO_PRESET,
        "-c:a", "aac", "-b:a", "192k",
        "-sn",
    ]

    if video_container == "mp4":
        cmd.extend(["-movflags", "+faststart"])

    cmd.append(str(output_path))

    run_video_command(cmd, dry_run, file_path, output_path, remove_source, duration)


def scan_files(target_dir: Path) -> Tuple[List[Path], List[Path]]:
    """Scans for all relevant files in one pass using fd."""
    logger.info("Scanning for files...")
    
    cmd = ["fd", "--type", "f", "--absolute-path", "--print0"]
    all_exts = IMG_EXTS.union(VID_EXTS)
    for ext in all_exts:
        cmd.extend(["-e", ext.lstrip('.')])
    cmd.extend([".", str(target_dir)])

    try:
        result = subprocess.run(cmd, capture_output=True, check=True)
        files = [Path(p.decode('utf-8')) for p in result.stdout.split(b'\0') if p]
    except subprocess.CalledProcessError as e:
        logger.error(f"fd search failed: {e}")
        return [], []

    images = []
    videos = []
    for f in files:
        suffix = f.suffix.lower()
        if suffix in IMG_EXTS:
            images.append(f)
        elif suffix in VID_EXTS:
            videos.append(f)
            
    return images, videos

def main():
    parser = argparse.ArgumentParser(description="Batch convert media using fd, ffmpeg and magick.")
    parser.add_argument("--dir", default=".", help="Target directory")
    parser.add_argument("-d", "--debug", action="store_true", help="Enable debug logging")
    parser.add_argument("-n", "--dry-run", action="store_true", help="Dry run mode")
    parser.add_argument("--rm", action="store_true", help="Remove source file after successful conversion")
    parser.add_argument("-j", "--workers", type=int, default=3, help="Number of parallel workers")
    parser.add_argument("--video-container", choices=["mp4", "mkv"], default="mp4", help="Video output container format")
    parser.add_argument("--picture-quality", type=int, default=85, help="Image quality for magick")
    parser.add_argument("--picture-format", choices=["webp", "avif"], default="webp", help="Image output format for magick")
    
    args = parser.parse_args()

    if args.debug:
        logger.setLevel(logging.DEBUG)
    else:
        logger.setLevel(logging.INFO)

    check_dependencies()

    target_path = Path(args.dir).resolve()
    if not target_path.exists():
        logger.error(f"Directory not found: {target_path}")
        sys.exit(1)

    if args.rm and not args.dry_run:
        logger.warning("!!! [WARNING] --rm flag is set. Source files will be DELETED after conversion. !!!")
        # Optional: Add a 3-second sleep to let user Ctrl+C if they panic
        # import time; time.sleep(3)

    logger.info(f"Starting Smart Media Converter in: {target_path} (Workers: {args.workers})")

    image_files, video_files = scan_files(target_path)
    total_files = len(image_files) + len(video_files)
    logger.info(f"Found {total_files} files ({len(image_files)} images, {len(video_files)} videos).")

    if total_files == 0:
        logger.info("Nothing to do.")
        return

    with ThreadPoolExecutor(max_workers=args.workers) as executor:
        futures = []
        
        for img in image_files:
            futures.append(executor.submit(convert_image, img, args.dry_run, args.rm, args.picture_quality, args.picture_format))
        
        for vid in video_files:
            futures.append(executor.submit(convert_video, vid, args.dry_run, args.rm, args.video_container))

        for future in as_completed(futures):
            try:
                future.result()
            except Exception as e:
                logger.error(f"Task exception: {e}")

    logger.info("All tasks completed.")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        logger.warning("\nInterrupted by user. Exiting...")
        sys.exit(130)
