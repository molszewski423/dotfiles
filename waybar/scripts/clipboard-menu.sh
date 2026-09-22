#!/usr/bin/env bash
set -euo pipefail

clear_label="🗑 Clear Clipboard History"

menu="$clear_label
$(cliphist list)"

selected=$(echo "$menu" | wofi --dmenu --prompt "Clipboard" --width 700 --height 500)
[ -n "$selected" ] || exit 0

if [ "$selected" = "$clear_label" ]; then
    wl-copy --clear
    pkill -x wl-paste || true
    rm -f ~/.cache/cliphist/db
    setsid nohup wl-paste --watch cliphist store >/dev/null 2>&1 &
    disown
    exit 0
fi

echo "$selected" | cliphist decode | wl-copy
