#!/usr/bin/env bash

set -euo pipefail

LOG_LEVEL="${LOG_LEVEL:-INFO}"
REENCODE=false
VIDEO_CODEC="libx264"
AUDIO_CODEC="aac"
CRF="18"
PRESET="medium"
AUDIO_BITRATE="192k"

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
Usage: $(basename "$0") [options] <video> [output_mp4]

Positional:
  <video>                 input video file (required, typically .webm or .mkv)
  [output_mp4]            output mp4 path (default: <video_name>.mp4)

Options:
  -d, --debug             enable debug logs
  --reencode              re-encode to H.264/AAC instead of stream copy
  --crf N                 video CRF for re-encode mode (default: 18)
  --preset NAME           x264 preset for re-encode mode (default: medium)
  --video-codec CODEC     explicit video codec for re-encode mode (default: libx264)
  --audio-codec CODEC     explicit audio codec for re-encode mode (default: aac)
  --audio-bitrate RATE    audio bitrate for re-encode mode (default: 192k)
  -h, --help              show this help and exit

Examples:
  $(basename "$0") clip.webm
  $(basename "$0") movie.mkv movie.mp4
  $(basename "$0") --reencode screencast.webm
  $(basename "$0") --reencode --crf 21 --preset slow input.mkv output.mp4
EOF
}

require_command() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    log_error "Required command not found: $cmd"
    exit 1
  fi
}

parse_args() {
  local positional=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -d | --debug)
      LOG_LEVEL="DEBUG"
      shift
      ;;
    --reencode)
      REENCODE=true
      shift
      ;;
    --crf)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for --crf"
        exit 1
      }
      CRF="$2"
      shift 2
      ;;
    --preset)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for --preset"
        exit 1
      }
      PRESET="$2"
      shift 2
      ;;
    --video-codec)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for --video-codec"
        exit 1
      }
      VIDEO_CODEC="$2"
      shift 2
      ;;
    --audio-codec)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for --audio-codec"
        exit 1
      }
      AUDIO_CODEC="$2"
      shift 2
      ;;
    --audio-bitrate)
      [[ $# -ge 2 ]] || {
        log_error "Missing value for --audio-bitrate"
        exit 1
      }
      AUDIO_BITRATE="$2"
      shift 2
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
  OUTPUT_PATH="${positional[1]:-}"
}

infer_output_path() {
  local input="$1"
  local base name dir
  base="$(basename "$input")"
  name="${base%.*}"
  dir="$(dirname "$input")"
  printf '%s/%s.mp4\n' "$dir" "$name"
}

build_ffmpeg_args() {
  local -a args

  args=(-hide_banner -loglevel error -y -i "$VIDEO_PATH" -map 0:v -map 0:a?)

  if [[ $REENCODE == true ]]; then
    args+=(-c:v "$VIDEO_CODEC" -preset "$PRESET" -crf "$CRF")
    args+=(-c:a "$AUDIO_CODEC" -b:a "$AUDIO_BITRATE")
  else
    args+=(-c copy)
  fi

  args+=(-movflags +faststart "$OUTPUT_PATH")
  printf '%s\n' "${args[@]}"
}

main() {
  parse_args "$@"

  require_command ffmpeg

  if [[ ! -f $VIDEO_PATH ]]; then
    log_error "Video file not found: $VIDEO_PATH"
    exit 1
  fi

  if [[ -z $OUTPUT_PATH ]]; then
    OUTPUT_PATH="$(infer_output_path "$VIDEO_PATH")"
  fi

  case "${VIDEO_PATH##*.}" in
  webm | WebM | mkv | MKV) ;;
  *)
    log_info "Input is not .webm/.mkv; proceeding anyway"
    ;;
  esac

  if [[ ${OUTPUT_PATH##*.} != "mp4" ]]; then
    log_error "Output file must end with .mp4"
    exit 1
  fi

  local -a ffmpeg_args
  mapfile -t ffmpeg_args < <(build_ffmpeg_args)

  log_info "Input: $VIDEO_PATH"
  log_info "Output: $OUTPUT_PATH"
  if [[ $REENCODE == true ]]; then
    log_info "Mode: re-encode (${VIDEO_CODEC}/${AUDIO_CODEC})"
  else
    log_info "Mode: stream copy"
  fi
  log_debug "ffmpeg ${ffmpeg_args[*]}"

  ffmpeg "${ffmpeg_args[@]}"

  log_info "MP4 written: $OUTPUT_PATH"
}

main "$@"
