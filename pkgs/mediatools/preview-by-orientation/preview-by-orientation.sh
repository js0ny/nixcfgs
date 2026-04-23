#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  preview_by_orientation.sh [landscape|portrait|square] [dir] [viewer]

Examples:
  preview_by_orientation.sh landscape ~/Pictures gwenview
  preview_by_orientation.sh portrait . qimgv
  preview_by_orientation.sh square . feh
EOF
}

orientation="${1:-landscape}"
dir="${2:-.}"
viewer="${3:-gwenview}"

case "$orientation" in
landscape | portrait | square) ;;
l) orientation="landscape" ;;
p) orientation="portrait" ;;
s) orientation="square" ;;
-h | --help)
  usage
  exit 0
  ;;
*)
  echo "Invalid orientation: $orientation" >&2
  usage
  exit 1
  ;;
esac

if [[ ! -d $dir ]]; then
  echo "Directory not found: $dir" >&2
  exit 1
fi

search_dir="$(cd "$dir" && pwd -P)"

if ! command -v "$viewer" >/dev/null 2>&1; then
  echo "Viewer not found: $viewer" >&2
  exit 1
fi

if command -v magick >/dev/null 2>&1; then
  IDENTIFY=(magick identify)
elif command -v identify >/dev/null 2>&1; then
  IDENTIFY=(identify)
else
  echo "ImageMagick is required: install 'imagemagick'" >&2
  exit 1
fi

selected=()

while IFS= read -r -d '' file; do
  dims="$("${IDENTIFY[@]}" -ping -format '%w %h' "$file" 2>/dev/null || true)"
  [[ -z $dims ]] && continue

  read -r w h <<<"$dims"
  [[ -z ${w:-} || -z ${h:-} ]] && continue

  case "$orientation" in
  landscape) ((w > h)) && selected+=("$file") ;;
  portrait) ((h > w)) && selected+=("$file") ;;
  square) ((w == h)) && selected+=("$file") ;;
  esac
done < <(
  find "$search_dir" -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \
    -o -iname '*.bmp' -o -iname '*.gif' -o -iname '*.tif' -o -iname '*.tiff' \
    -o -iname '*.heic' -o -iname '*.avif' \) \
    -print0
)

if ((${#selected[@]} == 0)); then
  echo "No $orientation images found in: $dir"
  exit 0
fi

echo "Opening ${#selected[@]} $orientation images with $viewer ..."
"$viewer" -- "${selected[@]}"
