#!/usr/bin/env bash

LOCK="  Lock"
SLEEP="  Sleep"
RESTART="  Restart"
SHUTDOWN="  Shutdown"
LOGOUT="  Logout"

chosen=$(printf '%s\n' "$LOCK" "$SLEEP" "$RESTART" "$SHUTDOWN" "$LOGOUT" \
    | wofi --dmenu \
        --conf /home/mike/.config/wofi/power.conf \
        --cache-file /dev/null \
        --prompt "  Power")

case "$chosen" in
    "$LOCK")     swaylock -f --color 1a1b26 --inside-color 24283b --ring-color bb9af7 \
                     --key-hl-color 9ece6a --bs-hl-color f7768e --text-color c0caf5 \
                     --inside-wrong-color f7768e --ring-wrong-color f7768e \
                     --inside-ver-color bb9af7 --ring-ver-color bb9af7 ;;
    "$SLEEP")    systemctl suspend ;;
    "$RESTART")  systemctl reboot ;;
    "$SHUTDOWN") systemctl poweroff ;;
    "$LOGOUT")
        systemctl --user stop gsd-rfkill.service polkit-kde-authentication-agent-1.service
        if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
            hyprctl dispatch exit
        elif [ -n "$NIRI_SOCKET" ]; then
            niri msg action quit skip-confirmation=true
        elif [ -n "$SWAYSOCK" ]; then
            swaymsg exit
        fi
        ;;
esac
