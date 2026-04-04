#!/usr/bin/env bash

set -euo pipefail

LOG_LEVEL="${LOG_LEVEL:-INFO}"
START_TIME=""
END_TIME=""
FORMAT=""
BITRATE="192k"
AUDIO_CODEC=""
AUDIO_STREAM="0"
COPY_AUDIO=false

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

  if [[ "$target_level" -ge "$current_level" ]]; then
    printf '[%s] [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$*" >&2
  fi
}

log_debug() { _log "DEBUG" "$@"; }
log_info() { _log "INFO" "$@"; }
log_error() { _log "ERROR" "$@"; }

print_usage() {
  cat <<EOF
Usage: $(basename "$0") [options] <video> [output_audio]

Positional:
  <video>                 input video file (required)
  [output_audio]          output audio path (default: <video_name>_audio.<format>)

Options:
  -d, --debug             enable debug logs
  --start SEC             extraction start time in seconds
  --end SEC               extraction end time in seconds
  --format FMT            output format: mp3|m4a|aac|wav|flac|opus|ogg
  --bitrate RATE          target audio bitrate for encoded output (default: 192k)
  --codec CODEC           explicit ffmpeg audio codec override
  --stream INDEX          audio stream index to extract (default: 0)
  --copy                  copy source audio stream without re-encoding
  -h, --help              show this help and exit

Examples:
  $(basename "$0") movie.mp4
  $(basename "$0") movie.mp4 soundtrack.mp3
  $(basename "$0") --start 30 --end 90 --format m4a movie.mp4 clip.m4a
  $(basename "$0") --stream 1 --copy concert.mkv concert_audio.aac
EOF
}

is_uint() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

is_ufloat() {
  [[ "$1" =~ ^[0-9]+([.][0-9]+)?$ ]]
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
      -d|--debug)
        LOG_LEVEL="DEBUG"
        shift
        ;;
      --start)
        [[ $# -ge 2 ]] || { log_error "Missing value for --start"; exit 1; }
        is_ufloat "$2" || { log_error "--start must be a non-negative number"; exit 1; }
        START_TIME="$2"
        shift 2
        ;;
      --end)
        [[ $# -ge 2 ]] || { log_error "Missing value for --end"; exit 1; }
        is_ufloat "$2" || { log_error "--end must be a non-negative number"; exit 1; }
        END_TIME="$2"
        shift 2
        ;;
      --format)
        [[ $# -ge 2 ]] || { log_error "Missing value for --format"; exit 1; }
        case "$2" in
          mp3|m4a|aac|wav|flac|opus|ogg)
            FORMAT="$2"
            ;;
          *)
            log_error "--format must be one of: mp3, m4a, aac, wav, flac, opus, ogg"
            exit 1
            ;;
        esac
        shift 2
        ;;
      --bitrate)
        [[ $# -ge 2 ]] || { log_error "Missing value for --bitrate"; exit 1; }
        BITRATE="$2"
        shift 2
        ;;
      --codec)
        [[ $# -ge 2 ]] || { log_error "Missing value for --codec"; exit 1; }
        AUDIO_CODEC="$2"
        shift 2
        ;;
      --stream)
        [[ $# -ge 2 ]] || { log_error "Missing value for --stream"; exit 1; }
        is_uint "$2" || { log_error "--stream must be a non-negative integer"; exit 1; }
        AUDIO_STREAM="$2"
        shift 2
        ;;
      --copy)
        COPY_AUDIO=true
        shift
        ;;
      -h|--help)
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

  if [[ "${#positional[@]}" -lt 1 ]]; then
    log_error "Missing required argument: video file"
    print_usage
    exit 1
  fi

  VIDEO_PATH="${positional[0]}"
  OUTPUT_AUDIO="${positional[1]:-}"
}

get_video_duration() {
  ffprobe -v error -show_entries format=duration -of default=nokey=1:noprint_wrappers=1 "$1"
}

infer_format_from_output() {
  local output="$1"
  local ext
  ext="${output##*.}"
  ext="${ext,,}"

  case "$ext" in
    mp3|m4a|aac|wav|flac|opus|ogg)
      echo "$ext"
      ;;
    *)
      echo ""
      ;;
  esac
}

default_codec_for_format() {
  case "$1" in
    mp3) echo "libmp3lame" ;;
    m4a|aac) echo "aac" ;;
    wav) echo "pcm_s16le" ;;
    flac) echo "flac" ;;
    opus) echo "libopus" ;;
    ogg) echo "libvorbis" ;;
    *)
      log_error "Unsupported format: $1"
      return 1
      ;;
  esac
}

build_codec_args() {
  local format="$1"

  if [[ "$COPY_AUDIO" == true ]]; then
    printf '%s\n' -c:a copy
    return 0
  fi

  local codec
  if [[ -n "$AUDIO_CODEC" ]]; then
    codec="$AUDIO_CODEC"
  else
    codec="$(default_codec_for_format "$format")"
  fi

  case "$format" in
    wav|flac)
      printf '%s\n' -c:a "$codec"
      ;;
    opus)
      printf '%s\n' -c:a "$codec" -b:a "$BITRATE" -vbr on
      ;;
    *)
      printf '%s\n' -c:a "$codec" -b:a "$BITRATE"
      ;;
  esac
}

extract_audio() {
  local video="$1"
  local output="$2"
  local format="$3"
  local -a ffmpeg_args codec_args

  mapfile -t codec_args < <(build_codec_args "$format")

  ffmpeg_args=(-hide_banner -loglevel error -y)

  if [[ -n "$START_TIME" ]]; then
    ffmpeg_args+=(-ss "$START_TIME")
  fi
  if [[ -n "$END_TIME" ]]; then
    ffmpeg_args+=(-to "$END_TIME")
  fi

  ffmpeg_args+=(-i "$video" -map "0:a:${AUDIO_STREAM}")
  ffmpeg_args+=("${codec_args[@]}")
  ffmpeg_args+=("$output")

  log_debug "ffmpeg ${ffmpeg_args[*]}"
  ffmpeg "${ffmpeg_args[@]}"
}

main() {
  parse_args "$@"

  require_command ffmpeg
  require_command ffprobe
  require_command awk

  if [[ ! -f "$VIDEO_PATH" ]]; then
    log_error "Video file not found: $VIDEO_PATH"
    exit 1
  fi

  local duration
  duration="$(get_video_duration "$VIDEO_PATH")"
  if [[ ! "$duration" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
    log_error "Failed to read video duration from ffprobe"
    exit 1
  fi

  if [[ -n "$START_TIME" ]] && [[ "$(awk -v s="$START_TIME" -v d="$duration" 'BEGIN {print (s >= d) ? 1 : 0}')" -eq 1 ]]; then
    log_error "--start ($START_TIME) must be less than video duration ($duration)"
    exit 1
  fi

  if [[ -n "$END_TIME" ]] && [[ "$(awk -v e="$END_TIME" -v d="$duration" 'BEGIN {print (e > d) ? 1 : 0}')" -eq 1 ]]; then
    log_error "--end ($END_TIME) is greater than video duration ($duration)"
    exit 1
  fi

  if [[ -n "$START_TIME" && -n "$END_TIME" ]] && [[ "$(awk -v s="$START_TIME" -v e="$END_TIME" 'BEGIN {print (e <= s) ? 1 : 0}')" -eq 1 ]]; then
    log_error "--end must be greater than --start (start=$START_TIME, end=$END_TIME)"
    exit 1
  fi

  if [[ -z "$OUTPUT_AUDIO" ]]; then
    local base name
    base="$(basename "$VIDEO_PATH")"
    name="${base%.*}"
    if [[ -z "$FORMAT" ]]; then
      FORMAT="mp3"
    fi
    OUTPUT_AUDIO="${name}_audio.${FORMAT}"
  fi

  if [[ -z "$FORMAT" ]]; then
    FORMAT="$(infer_format_from_output "$OUTPUT_AUDIO")"
    if [[ -z "$FORMAT" ]]; then
      log_error "Cannot infer format from output path. Please set --format (mp3|m4a|aac|wav|flac|opus|ogg)."
      exit 1
    fi
  fi

  if [[ "$COPY_AUDIO" == true && -n "$AUDIO_CODEC" ]]; then
    log_error "--copy cannot be used together with --codec"
    exit 1
  fi

  log_info "Video: $VIDEO_PATH"
  log_info "Duration: ${duration}s"
  if [[ -n "$START_TIME" || -n "$END_TIME" ]]; then
    log_info "Range: ${START_TIME:-0}s -> ${END_TIME:-${duration}}s"
  fi
  log_info "Audio stream: $AUDIO_STREAM"
  log_info "Format: $FORMAT"
  if [[ "$COPY_AUDIO" == true ]]; then
    log_info "Mode: stream copy"
  else
    log_info "Bitrate: $BITRATE"
    if [[ -n "$AUDIO_CODEC" ]]; then
      log_info "Codec override: $AUDIO_CODEC"
    fi
  fi

  log_info "Extracting audio -> $OUTPUT_AUDIO"
  extract_audio "$VIDEO_PATH" "$OUTPUT_AUDIO" "$FORMAT"
  log_info "Audio extracted: $OUTPUT_AUDIO"
}

main "$@"
