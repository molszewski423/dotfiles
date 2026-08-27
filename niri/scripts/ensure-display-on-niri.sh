#!/usr/bin/env bash
# niri counterpart to ~/.config/sway/scripts/ensure-display-on.sh.
#
# That script retries 'output * power on' in a loop because swaymsg would report
# success immediately after a real suspend/resume even though the kernel's DRM
# subsystem hadn't actually finished resuming yet - a single call could silently
# no-op and leave the screen black.
#
# niri's `niri msg -j outputs` doesn't have a confirmed stable field for "is this
# output actually powered on" (unlike sway's "power": true/false), so this can't
# poll-and-verify the same way without risking exactly the kind of silent false
# positive the sway version was written to avoid. Instead this just retries the
# power-on action a few times over ~2 seconds as a blunter safety net.
for i in $(seq 1 10); do
    niri msg action power-on-monitors >/dev/null 2>&1
    sleep 0.2
done
