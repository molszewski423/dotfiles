#!/usr/bin/env bash
set -euo pipefail

selected=$(cliphist list | wofi --dmenu --prompt "Clipboard" --width 700 --height 500)
[ -n "$selected" ] || exit 0
echo "$selected" | cliphist decode | wl-copy
