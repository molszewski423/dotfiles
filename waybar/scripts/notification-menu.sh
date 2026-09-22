#!/usr/bin/env bash
set -euo pipefail

if makoctl mode | grep -qx "do-not-disturb"; then
    toggle_label="🔔 Disable Do Not Disturb"
else
    toggle_label="🔕 Enable Do Not Disturb"
fi
clear_label="🗑 Clear All Notifications"
separator="──────────"

notifications=$(
  { makoctl list -j 2>/dev/null; makoctl history -j 2>/dev/null; } \
    | jq -s -r 'add | unique_by(.id) | sort_by(-.id) |
        .[] | "[\(.id)] \(.summary) — \(.body // "" | gsub("\n";" ") | .[0:80])"' 2>/dev/null || true
)

menu="$toggle_label
$clear_label"
[ -n "$notifications" ] && menu="$menu
$separator
$notifications"

choice=$(echo "$menu" | wofi --dmenu --prompt "Notifications" --width 500 --height 400)

case "$choice" in
    "")
        exit 0
        ;;
    "$toggle_label")
        makoctl mode -t do-not-disturb >/dev/null
        ;;
    "$clear_label")
        pkill -x mako || true
        sleep 0.3
        mako &
        disown
        ;;
    "$separator")
        exit 0
        ;;
    \[*)
        id=$(echo "$choice" | sed -n 's/^\[\([0-9]*\)\].*/\1/p')
        [ -n "$id" ] && makoctl dismiss -n "$id" >/dev/null 2>&1 || true
        ;;
esac
