#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

mapfile -d '' files < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -print0)

if [ "${#files[@]}" -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR" >&2
    exit 1
fi

pick="${files[RANDOM % ${#files[@]}]}"

pkill -x swaybg || true
swaybg -o '*' -i "$pick" -m fill &
disown
