#!/usr/bin/env bash

set -euo pipefail

LOG_LEVEL="${LOG_LEVEL:-INFO}"
CRF="${TO_AV1_CRF:-32}"
PRESET="${TO_AV1_PRESET:-8}"

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

log_info() { _log "INFO" "$@"; }
log_error() { _log "ERROR" "$@"; }

print_usage() {
  cat <<EOF
Usage: $(basename "$0") [options] <video1> [video2] ...

Options:
  -d, --debug     enable debug logs
  --crf N         set AV1 CRF (default: ${TO_AV1_CRF:-32})
  --preset N      set SVT-AV1 preset (default: ${TO_AV1_PRESET:-8})
  -h, --help      show this help and exit
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
  INPUTS=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -d | --debug)
      LOG_LEVEL="DEBUG"
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
    -h | --help)
      print_usage
      exit 0
      ;;
    --)
      shift
      while [[ $# -gt 0 ]]; do
        INPUTS+=("$1")
        shift
      done
      ;;
    -*)
      log_error "Unknown option: $1"
      print_usage
      exit 1
      ;;
    *)
      INPUTS+=("$1")
      shift
      ;;
    esac
  done

  if [[ ${#INPUTS[@]} -eq 0 ]]; then
    log_error "Missing required input files"
    print_usage
    exit 1
  fi
}

main() {
  parse_args "$@"
  require_command ffmpeg

  local input output
  for input in "${INPUTS[@]}"; do
    if [[ ! -f $input ]]; then
      log_error "File not found: $input"
      continue
    fi

    output="${input%.*}.av1.mkv"
    log_info "Encoding: $input -> $output (AV1, CRF $CRF, preset $PRESET)"

    ffmpeg -hide_banner -loglevel error -y -i "$input" \
      -map 0 \
      -c:v libsvtav1 -crf "$CRF" -preset "$PRESET" \
      -c:a copy \
      -c:s copy \
      "$output"
  done

  log_info "Done"
}

main "$@"
