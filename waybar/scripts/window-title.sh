#!/usr/bin/env bash
set -euo pipefail

exec 201>/tmp/window-title.lock
flock -w 1 201 || exit 0

title=$(swaymsg -t get_tree | jq -r '[.. | select(.focused? == true and .type != "workspace") | .name] | first // ""')

if [ "${#title}" -gt 60 ]; then
    title="${title:0:57}..."
fi

jq -nc --arg t "$title" '{text: $t, tooltip: $t}'
