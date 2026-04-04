#!/usr/bin/env bash

set -euo pipefail

QUALITY="${TO_WEBP_QUALITY:-85}"

print_usage() {
  cat <<EOF
Usage: $(basename "$0") [options] <image1> [image2] ...

Options:
  --quality N    set WebP quality (default: ${TO_WEBP_QUALITY:-85})
  -h, --help     show this help and exit
EOF
}

require_command() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    printf 'Required command not found: %s\n' "$cmd" >&2
    exit 1
  fi
}

parse_args() {
  INPUTS=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --quality)
        [[ $# -ge 2 ]] || { printf 'Missing value for --quality\n' >&2; exit 1; }
        QUALITY="$2"
        shift 2
        ;;
      -h|--help)
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
        printf 'Unknown option: %s\n' "$1" >&2
        print_usage
        exit 1
        ;;
      *)
        INPUTS+=("$1")
        shift
        ;;
    esac
  done

  if [[ "${#INPUTS[@]}" -eq 0 ]]; then
    printf 'Missing required input files\n' >&2
    print_usage
    exit 1
  fi
}

main() {
  parse_args "$@"
  require_command magick
  require_command exiftool

  local input output
  for input in "${INPUTS[@]}"; do
    if [[ ! -f "$input" ]]; then
      printf 'File not found: %s\n' "$input" >&2
      continue
    fi

    output="${input%.*}.webp"
    printf 'Converting: %s -> %s (quality %s)\n' "$input" "$output" "$QUALITY"
    magick "$input" -quality "$QUALITY" "$output"
    exiftool -TagsFromFile "$input" -all:all "$output" -overwrite_original >/dev/null
  done

  printf 'Done\n'
}

main "$@"
