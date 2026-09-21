#!/usr/bin/env bash
set -euo pipefail

mkdir -p ~/Pictures/Screenshots

OUTPUT=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused == true) | .name')

if [ -z "$OUTPUT" ]; then
    notify-send "Screenshot failed" "Could not determine focused output"
    exit 1
fi

FILE="$HOME/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"
grim -o "$OUTPUT" "$FILE"
wl-copy < "$FILE"
notify-send "Screenshot saved" "$FILE (copied to clipboard)"
