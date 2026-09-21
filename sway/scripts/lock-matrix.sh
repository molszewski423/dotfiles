#!/usr/bin/env bash
set -euo pipefail

# mpvpaper's own stdout/stderr isn't journal-captured when launched this way (via
# swaylock-plugin's --command, itself launched from swayidle's before-sleep hook) -
# logging to a file so a post-suspend EGL failure (seen once, 2026-08-22) can
# actually be diagnosed next time instead of vanishing silently.
exec "$HOME/.local/bin/swaylock-plugin" -f --command "$HOME/.local/bin/mpvpaper -o 'loop-file=inf --no-audio' ALL $HOME/.local/share/backgrounds/matrix-purple-loop.mp4 >> $HOME/.cache/mpvpaper-lock.log 2>&1" \
    --color 1a1b26 --inside-color 24283b --ring-color 7aa2f7 \
    --key-hl-color 9ece6a --bs-hl-color f7768e --text-color c0caf5 \
    --inside-wrong-color f7768e --ring-wrong-color f7768e \
    --inside-ver-color 7aa2f7 --ring-ver-color bb9af7
