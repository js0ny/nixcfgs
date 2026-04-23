#!/usr/bin/env bash
# vim:ft=bash
# shellcheck shell=bash
# gen-grid.sh
# Date: 2026-03-22
# Author: js0ny
# Requires: ffmpeg ffprobe awk bash >= 4
# Notes: Extract evenly spaced frames from a video and compose a grid image.

set -euo pipefail

LOG_LEVEL="${LOG_LEVEL:-INFO}"
ROWS=3
COLS=3
START_TIME=0
END_TIME=""
THUMB_SIZE="320x180"
PADDING=0
MARGIN=0
BG_COLOR="black"
KEEP_FRAMES=false
TMPDIR_CLEANUP=""
FORMAT=""

_log_level_num() {
  case "$1" in
  DEBUG) echo 0 ;;
  INFO) echo 1 ;;
  ERROR) echo 2 ;;
  *) echo 1 ;;
  esac
}

_log() {
  local level="$1"
  shift
  local current_level target_level
  current_level="$(_log_level_num "$LOG_LEVEL")"
  target_level="$(_log_level_num "$level")"

  if [[ $target_level -ge $current_level ]]; then
    printf '[%s] [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$*" >&2
  fi
}

log_debug() { _log "DEBUG" "$@"; }
log_info() { _log "INFO" "$@"; }
log_error() { _log "ERROR" "$@"; }

print_usage() {
  cat <<EOF
Usage: $(basename "$0") [options] <video> [output_image] [grid_size]

Positional (backward compatible):
  <video>                 input video file (required)
  [output_image]          output image path (default: <video_name>_grid.png)
  [grid_size]             square grid N, equivalent to --rows N --cols N

Options:
  -d, --debug             enable debug logs
  -g, --grid N            set square grid size (N x N)
  --rows N                grid rows (default: 3)
  --cols N                grid cols (default: 3)
  --start SEC             sampling start time in seconds (default: 0)
  --end SEC               sampling end time in seconds (default: video duration)
  --thumb-size WxH        thumbnail size per cell (default: 320x180)
  --padding N             pixels between cells (default: 0)
  --margin N              outer border pixels (default: 0)
  --bg COLOR              background color (default: black)
  --format FMT            output format: png|jpg|jpeg|webp|avif
  --keep-frames           keep extracted temp frames for debugging
  -h, --help              show this help and exit

Examples:
  $(basename "$0") movie.mp4
  $(basename "$0") movie.mp4 grid.png 4
  $(basename "$0") --rows 2 --cols 5 --thumb-size 240x135 movie.mp4 output.png
  $(basename "$0") --start 30 --end 120 -g 5 movie.mp4
  $(basename "$0") --format avif movie.mp4 cover.avif
EOF
}

is_uint() {
  [[ $1 =~ ^[0-9]+$ ]]
}

is_ufloat() {
  [[ $1 =~ ^[0-9]+([.][0-9]+)?$ ]]
}

require_command() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    log_error "Required command not found: $cmd"
    exit 1
  fi
}

parse_thumb_size() {
  if [[ ! $THUMB_SIZE =~ ^([0-9]+)x([0-9]+)$ ]]; then
    log_error "Invalid --thumb-size format: $THUMB_SIZE (expected WxH, e.g. 320x180)"
    exit 1
  fi
  THUMB_W="${BASH_REMATCH[1]}"
  THUMB_H="${BASH_REMATCH[2]}"
}

get_video_duration() {
  ffprobe -v error -show_entries format=duration -of default=nokey=1:noprint_wrappers=1 "$1"
}

parse_args() {
  local positional=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -d | --debug)
      LOG_LEVEL="DEBUG"
      shift
      ;;
    -g | --grid)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for $1"
        exit 1
      }
      is_uint "$2" || {
        log_error "--grid must be a non-negative integer"
        exit 1
      }
      ROWS="$2"
      COLS="$2"
      shift 2
      ;;
    --rows)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for --rows"
        exit 1
      }
      is_uint "$2" || {
        log_error "--rows must be a non-negative integer"
        exit 1
      }
      ROWS="$2"
      shift 2
      ;;
    --cols)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for --cols"
        exit 1
      }
      is_uint "$2" || {
        log_error "--cols must be a non-negative integer"
        exit 1
      }
      COLS="$2"
      shift 2
      ;;
    --start)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for --start"
        exit 1
      }
      is_ufloat "$2" || {
        log_error "--start must be a non-negative number"
        exit 1
      }
      START_TIME="$2"
      shift 2
      ;;
    --end)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for --end"
        exit 1
      }
      is_ufloat "$2" || {
        log_error "--end must be a non-negative number"
        exit 1
      }
      END_TIME="$2"
      shift 2
      ;;
    --thumb-size)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for --thumb-size"
        exit 1
      }
      THUMB_SIZE="$2"
      shift 2
      ;;
    --padding)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for --padding"
        exit 1
      }
      is_uint "$2" || {
        log_error "--padding must be a non-negative integer"
        exit 1
      }
      PADDING="$2"
      shift 2
      ;;
    --margin)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for --margin"
        exit 1
      }
      is_uint "$2" || {
        log_error "--margin must be a non-negative integer"
        exit 1
      }
      MARGIN="$2"
      shift 2
      ;;
    --bg)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for --bg"
        exit 1
      }
      BG_COLOR="$2"
      shift 2
      ;;
    --format)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for --format"
        exit 1
      }
      case "$2" in
      png | jpg | jpeg | webp | avif)
        FORMAT="$2"
        ;;
      *)
        log_error "--format must be one of: png, jpg, jpeg, webp, avif"
        exit 1
        ;;
      esac
      shift 2
      ;;
    --keep-frames)
      KEEP_FRAMES=true
      shift
      ;;
    -h | --help)
      print_usage
      exit 0
      ;;
    --)
      shift
      while [[ $# -gt 0 ]]; do
        positional+=("$1")
        shift
      done
      ;;
    -*)
      log_error "Unknown option: $1"
      print_usage
      exit 1
      ;;
    *)
      positional+=("$1")
      shift
      ;;
    esac
  done

  if [[ ${#positional[@]} -lt 1 ]]; then
    log_error "Missing required argument: video file"
    print_usage
    exit 1
  fi

  VIDEO_PATH="${positional[0]}"
  OUTPUT_IMAGE="${positional[1]:-}"

  if [[ -n ${positional[2]:-} ]]; then
    is_uint "${positional[2]}" || {
      log_error "grid_size positional argument must be a non-negative integer"
      exit 1
    }
    ROWS="${positional[2]}"
    COLS="${positional[2]}"
  fi
}

extract_frames() {
  local video="$1"
  local count="$2"
  local outdir="$3"
  local sample_start="$4"
  local sample_end="$5"

  local interval
  interval="$(awk -v s="$sample_start" -v e="$sample_end" -v n="$count" 'BEGIN {print (e - s) / (n + 1)}')"
  if [[ "$(awk -v x="$interval" 'BEGIN {print (x <= 0) ? 1 : 0}')" -eq 1 ]]; then
    log_error "Computed sampling interval is not positive: $interval"
    return 1
  fi

  local i t out
  for ((i = 1; i <= count; i++)); do
    t="$(awk -v s="$sample_start" -v step="$interval" -v idx="$i" 'BEGIN {print s + step * idx}')"
    out="$outdir/frame_$(printf '%04d' "$i").png"
    ffmpeg -hide_banner -loglevel error -y -ss "$t" -i "$video" -frames:v 1 \
      -vf "scale=${THUMB_W}:${THUMB_H}:force_original_aspect_ratio=decrease,pad=${THUMB_W}:${THUMB_H}:(ow-iw)/2:(oh-ih)/2:color=${BG_COLOR}" \
      "$out"
    log_debug "Captured frame $i/$count at ${t}s -> $out"
  done
}

create_grid() {
  local input_dir="$1"
  local output="$2"
  local format="$3"
  local -a encode_opts

  case "$format" in
  png)
    encode_opts=()
    ;;
  jpg | jpeg)
    encode_opts=(-q:v 2)
    ;;
  webp)
    encode_opts=(-c:v libwebp -quality 90)
    ;;
  avif)
    encode_opts=(-c:v libaom-av1 -still-picture 1 -crf 30 -cpu-used 6 -pix_fmt yuv420p)
    ;;
  *)
    log_error "Unsupported format: $format"
    return 1
    ;;
  esac

  ffmpeg -hide_banner -loglevel error -y -framerate 1 -i "$input_dir/frame_%04d.png" \
    -frames:v 1 \
    -vf "tile=${COLS}x${ROWS}:padding=${PADDING}:margin=${MARGIN}:color=${BG_COLOR}" \
    "${encode_opts[@]}" \
    "$output"
}

infer_format_from_output() {
  local output="$1"
  local ext
  ext="${output##*.}"
  ext="${ext,,}"
  case "$ext" in
  png | jpg | jpeg | webp | avif)
    echo "$ext"
    ;;
  *)
    echo ""
    ;;
  esac
}

main() {
  parse_args "$@"

  require_command ffmpeg
  require_command ffprobe
  require_command awk

  if [[ ! -f $VIDEO_PATH ]]; then
    log_error "Video file not found: $VIDEO_PATH"
    exit 1
  fi

  if [[ $ROWS -eq 0 || $COLS -eq 0 ]]; then
    log_error "--rows and --cols must be >= 1"
    exit 1
  fi

  parse_thumb_size

  if [[ -z $OUTPUT_IMAGE ]]; then
    local base name
    base="$(basename "$VIDEO_PATH")"
    name="${base%.*}"
    if [[ -z $FORMAT ]]; then
      FORMAT="png"
    fi
    OUTPUT_IMAGE="${name}_grid.${FORMAT}"
  fi

  if [[ -z $FORMAT ]]; then
    FORMAT="$(infer_format_from_output "$OUTPUT_IMAGE")"
    if [[ -z $FORMAT ]]; then
      log_error "Cannot infer format from output path. Please set --format (png|jpg|jpeg|webp|avif)."
      exit 1
    fi
  fi

  local duration
  duration="$(get_video_duration "$VIDEO_PATH")"
  if [[ ! $duration =~ ^[0-9]+([.][0-9]+)?$ ]]; then
    log_error "Failed to read video duration from ffprobe"
    exit 1
  fi

  local sample_start sample_end
  sample_start="$START_TIME"
  sample_end="$END_TIME"
  if [[ -z $sample_end ]]; then
    sample_end="$duration"
  fi

  if [[ "$(awk -v s="$sample_start" -v e="$sample_end" 'BEGIN {print (e <= s) ? 1 : 0}')" -eq 1 ]]; then
    log_error "--end must be greater than --start (start=$sample_start, end=$sample_end)"
    exit 1
  fi
  if [[ "$(awk -v e="$sample_end" -v d="$duration" 'BEGIN {print (e > d) ? 1 : 0}')" -eq 1 ]]; then
    log_error "--end ($sample_end) is greater than video duration ($duration)"
    exit 1
  fi

  local total_frames
  total_frames=$((ROWS * COLS))

  log_info "Video: $VIDEO_PATH"
  log_info "Duration: ${duration}s"
  log_info "Sampling: ${sample_start}s -> ${sample_end}s"
  log_info "Grid: ${ROWS}x${COLS} (${total_frames} frames)"
  log_info "Thumb: ${THUMB_W}x${THUMB_H}, padding=${PADDING}, margin=${MARGIN}, bg=${BG_COLOR}, format=${FORMAT}"

  local tmpdir
  tmpdir="$(mktemp -d)"
  if [[ $KEEP_FRAMES == true ]]; then
    log_info "Keeping temp frames in: $tmpdir"
  else
    TMPDIR_CLEANUP="$tmpdir"
    trap 'rm -rf "$TMPDIR_CLEANUP"' EXIT
  fi

  extract_frames "$VIDEO_PATH" "$total_frames" "$tmpdir" "$sample_start" "$sample_end"

  log_info "Composing grid -> $OUTPUT_IMAGE"
  create_grid "$tmpdir" "$OUTPUT_IMAGE" "$FORMAT"

  log_info "Grid image generated: $OUTPUT_IMAGE"
}

main "$@"
