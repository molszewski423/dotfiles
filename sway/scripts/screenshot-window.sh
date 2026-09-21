#!/usr/bin/env bash
set -euo pipefail

mkdir -p ~/Pictures/Screenshots

GEOM=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)"' | head -1)

if [ -z "$GEOM" ]; then
    notify-send "Screenshot failed" "Could not find focused window geometry"
    exit 1
fi

FILE="$HOME/Pictures/Screenshots/screenshot-window-$(date +%Y%m%d-%H%M%S).png"
grim -g "$GEOM" "$FILE"
wl-copy < "$FILE"
notify-send "Screenshot saved" "$FILE (copied to clipboard)"
