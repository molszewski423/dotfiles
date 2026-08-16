#!/usr/bin/env bash
# Watches for gstreamer1-plugins-base version drift against the version the
# source-built ffmpeg 7.1.5 + gst-libav 1.26.7 (~/src/gst-libav-1.26.7) was built
# against. That build has no dnf tracking at all, so a dnf update touching
# gstreamer1-* can silently break HLS/Udemy video in native Firefox with no error —
# see project_thinkpad_native_firefox in Mike's memory for the full story.
#
# Triggered automatically after any rpm transaction via
# ~/.config/systemd/user/gstreamer-abi-watch.path (see install-rocky.sh).
#
# Usage:
#   check-gstreamer-abi.sh          check current version against the recorded baseline
#   check-gstreamer-abi.sh --record set the current version as the new baseline
#                                    (run this right after rebuilding gst-libav)

set -euo pipefail

STATE_FILE="$HOME/.config/gstreamer-abi-baseline"
CURRENT="$(rpm -q gstreamer1-plugins-base)"

if [[ "${1:-}" == "--record" ]]; then
    echo "$CURRENT" > "$STATE_FILE"
    echo "Recorded baseline: $CURRENT"
    exit 0
fi

if [[ ! -f "$STATE_FILE" ]]; then
    echo "$CURRENT" > "$STATE_FILE"
    exit 0
fi

BASELINE="$(cat "$STATE_FILE")"

if [[ "$CURRENT" != "$BASELINE" ]]; then
    MSG="gstreamer1-plugins-base changed ($BASELINE -> $CURRENT). The hand-built gst-libav plugin may need rebuilding — check HLS/Udemy video playback in Firefox. See ~/src/ffmpeg-7.1.5 and ~/src/gst-libav-1.26.7."
    echo "$MSG" >&2
    if command -v notify-send >/dev/null 2>&1; then
        notify-send -u critical "gstreamer ABI drift detected" "$MSG"
    fi
    # Don't silently update the baseline here — leave it pointing at the last
    # known-good version until Mike rebuilds and runs --record himself.
    exit 1
fi
