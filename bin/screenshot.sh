#!/bin/bash
FILE="/home/mike/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"
if [ "$1" = "window" ]; then
    REGION=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
    grim -g "$REGION" "$FILE"
else
    grim "$FILE"
fi
wl-copy < "$FILE"
notify-send "Screenshot saved" "Copied to clipboard — $FILE"
