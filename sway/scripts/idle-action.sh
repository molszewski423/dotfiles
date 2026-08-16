#!/usr/bin/env bash
# Runs the given idle command unless a media player is actively playing (MPRIS).
# Used by swayidle so video playback in a browser (YouTube/Netflix/etc) blocks
# screen-off and lock.

if playerctl -a status 2>/dev/null | grep -q Playing; then
    exit 0
fi

exec "$@"
