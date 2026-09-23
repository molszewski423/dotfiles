#!/usr/bin/env bash
set -euo pipefail

PIDFILE="/tmp/waybar-workspace-watch-subscribe.pid"
FIFO="/tmp/waybar-workspace-watch.fifo"

if [ -f "$PIDFILE" ]; then
    old_pid=$(cat "$PIDFILE")
    kill "$old_pid" 2>/dev/null || true
fi

rm -f "$FIFO"
mkfifo "$FIFO"

swaymsg -t subscribe -m '["workspace","window"]' > "$FIFO" &
echo $! > "$PIDFILE"

last=0
while read -r _; do
    now=$(date +%s%N)
    if [ $((now - last)) -gt 150000000 ]; then
        pkill -RTMIN+9 waybar || true
        pkill -RTMIN+10 waybar || true
        last=$now
    fi
done < "$FIFO"
