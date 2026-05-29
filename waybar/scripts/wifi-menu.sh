#!/usr/bin/env bash

# Trigger a background rescan
nmcli device wifi rescan &>/dev/null &

# Read network list in terse format (: separated, colons in SSIDs escaped as \:)
mapfile -t raw_nets < <(nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY device wifi list 2>/dev/null)

entries=()
ssid_map=()

for net in "${raw_nets[@]}"; do
    IFS=':' read -r inuse ssid signal security <<< "$net"
    ssid="${ssid//\\:/\:}"   # unescape literal colons in SSID
    [[ -z "$ssid" ]] && continue

    mark=$([[ "$inuse" == "*" ]] && echo "✓" || echo " ")
    sig=${signal//[!0-9]/}
    if   (( sig >= 75 )); then bars="▂▄▆█"
    elif (( sig >= 50 )); then bars="▂▄▆_"
    elif (( sig >= 25 )); then bars="▂▄__"
    else                       bars="▂___"; fi
    lock=$([[ "$security" != "--" && -n "$security" ]] && echo " 󰌾" || echo "")

    entry=$(printf "%s %s  %-30s %3s%%%s" "$mark" "$bars" "$ssid" "$sig" "$lock")
    entries+=("$entry")
    ssid_map+=("$ssid")
done

[[ ${#entries[@]} -eq 0 ]] && notify-send "WiFi" "No networks found" && exit 1

chosen=$(printf '%s\n' "${entries[@]}" | wofi --dmenu \
    --conf /home/mike/.config/wofi/wifi.conf \
    --cache-file /dev/null)

[[ -z "$chosen" ]] && exit 0

# Map chosen display line back to SSID via index
ssid=""
for i in "${!entries[@]}"; do
    if [[ "${entries[$i]}" == "$chosen" ]]; then
        ssid="${ssid_map[$i]}"
        break
    fi
done
[[ -z "$ssid" ]] && exit 0

# If we have a saved connection profile, bring it up silently
if nmcli connection show "$ssid" &>/dev/null; then
    nmcli connection up id "$ssid" \
        && notify-send "WiFi" "Connected to $ssid" \
        || notify-send -u critical "WiFi" "Failed to connect to $ssid"
else
    # New network — open a floating terminal with nmtui for password entry
    swaymsg 'for_window [app_id="kitty" title="wifi-connect"] floating enable, resize set 600 360, move position center'
    kitty --title "wifi-connect" -- nmtui connect "$ssid"
fi
