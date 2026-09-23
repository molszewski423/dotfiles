#!/usr/bin/env bash
set -euo pipefail

exec 200>/tmp/workspace-status.lock
flock -w 1 200 || exit 0

text=$(swaymsg -t get_workspaces | jq -r '
  sort_by(.num) |
  map(if .focused then "<span color=\"#bb9af7\" weight=\"bold\">\(.num)</span>" else "<span color=\"#565f89\">\(.num)</span>" end) |
  join("  ")
')

jq -nc --arg t "$text" '{text: $t, tooltip: "Workspaces (click-to-switch unavailable — waybar workaround)"}'
