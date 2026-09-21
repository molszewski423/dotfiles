#!/usr/bin/env bash
# Retries 'output * power on' until swaymsg confirms it actually took effect.
# After a real suspend/resume, swaymsg reports success immediately even if the
# kernel's DRM subsystem isn't finished resuming yet, and the power-on silently
# no-ops - confirmed 2026-08-22 (lid open -> screen stayed black, dpms/power
# both false, despite two separate handlers each reporting success).
for i in $(seq 1 30); do
    swaymsg 'output * power on' >/dev/null 2>&1
    if swaymsg -t get_outputs 2>/dev/null | grep -q '"power": true'; then
        exit 0
    fi
    sleep 0.1
done
