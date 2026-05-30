#!/usr/bin/env bash
LOCK="swaylock -f --color 1a1b26 --inside-color 24283b --ring-color 7aa2f7 \
    --key-hl-color 9ece6a --bs-hl-color f7768e --text-color c0caf5 \
    --inside-wrong-color f7768e --ring-wrong-color f7768e \
    --inside-ver-color 7aa2f7 --ring-ver-color bb9af7"

exec swayidle -w \
    timeout 300 "$LOCK" \
    timeout 600 "hyprctl dispatch dpms off" \
    resume "hyprctl dispatch dpms on" \
    before-sleep "$LOCK"
