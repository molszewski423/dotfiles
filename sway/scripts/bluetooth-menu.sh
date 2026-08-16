#!/bin/bash
# Bluetooth menu for Sway: wofi + bluetoothctl. Connect / disconnect / forget / toggle power.
set -euo pipefail

notify() { notify-send "Bluetooth" "$1"; }

scan_devices() {
    { echo "scan on"; sleep 5; echo "scan off"; echo "quit"; } | timeout 8 bluetoothctl >/dev/null 2>&1 || true
}

# "Device MAC Name..." lines -> "Name... [MAC]"
format_devices() {
    sed 's/^Device //' | awk '{mac=$1; $1=""; sub(/^ /,""); print $0" ["mac"]"}'
}

extract_mac() {
    grep -oP '\[\K[0-9A-Fa-f:]+(?=\])'
}

do_connect() {
    local devices menu choice mac name connected_macs
    notify "Scanning for devices (5s)..."
    scan_devices

    devices=$(timeout 5 bluetoothctl devices || true)
    if [ -z "$devices" ]; then
        notify "No devices found"
        return
    fi
    connected_macs=$(timeout 5 bluetoothctl devices Connected | awk '{print $2}' || true)

    menu=$(echo "$devices" | format_devices | while read -r line; do
        mac=$(echo "$line" | extract_mac)
        name="${line% \[*}"
        # skip devices broadcasting no real name (name == mac with dashes)
        [[ "$name" =~ ^[0-9A-Fa-f]{2}(-[0-9A-Fa-f]{2}){5}$ ]] && continue
        if echo "$connected_macs" | grep -qx "$mac"; then
            echo "$line (connected)"
        else
            echo "$line"
        fi
    done)

    if [ -z "$menu" ]; then
        notify "No named devices found"
        return
    fi

    choice=$(echo "$menu" | wofi --dmenu --prompt "Bluetooth devices")
    [ -z "$choice" ] && return
    mac=$(echo "$choice" | extract_mac)
    name="${choice% \[*}"
    [ -z "$mac" ] && return

    notify "Connecting to $name..."
    timeout 10 bluetoothctl pair "$mac" >/tmp/bt-menu-err 2>&1 || true
    timeout 5 bluetoothctl trust "$mac" >>/tmp/bt-menu-err 2>&1 || true
    if timeout 15 bluetoothctl connect "$mac" >>/tmp/bt-menu-err 2>&1; then
        notify "Connected to $name"
    else
        notify "Failed to connect to $name: $(tail -1 /tmp/bt-menu-err)"
    fi
}

do_disconnect() {
    local connected menu choice mac name
    connected=$(timeout 5 bluetoothctl devices Connected || true)
    if [ -z "$connected" ]; then
        notify "No connected devices"
        return
    fi
    menu=$(echo "$connected" | format_devices)
    choice=$(echo "$menu" | wofi --dmenu --prompt "Disconnect device")
    [ -z "$choice" ] && return
    mac=$(echo "$choice" | extract_mac)
    name="${choice% \[*}"
    if timeout 10 bluetoothctl disconnect "$mac" 2>/tmp/bt-menu-err; then
        notify "Disconnected $name"
    else
        notify "Failed to disconnect $name: $(cat /tmp/bt-menu-err)"
    fi
}

do_forget() {
    local paired menu choice mac name
    paired=$(timeout 5 bluetoothctl devices Paired || true)
    if [ -z "$paired" ]; then
        notify "No paired devices"
        return
    fi
    menu=$(echo "$paired" | format_devices)
    choice=$(echo "$menu" | wofi --dmenu --prompt "Forget device")
    [ -z "$choice" ] && return
    mac=$(echo "$choice" | extract_mac)
    name="${choice% \[*}"
    if timeout 10 bluetoothctl remove "$mac" 2>/tmp/bt-menu-err; then
        notify "Forgot $name"
    else
        notify "Failed to forget $name: $(cat /tmp/bt-menu-err)"
    fi
}

do_toggle_power() {
    local state
    state=$(timeout 5 bluetoothctl show | awk -F': ' '/Powered/{print $2}')
    if [ "$state" = "yes" ]; then
        timeout 5 bluetoothctl power off >/dev/null 2>&1 || true
        notify "Bluetooth off"
    else
        timeout 5 bluetoothctl power on >/dev/null 2>&1 || true
        notify "Bluetooth on"
    fi
}

action=$(printf '%s\n' "Connect to device" "Disconnect" "Forget device" "Toggle Bluetooth power" \
    | wofi --dmenu --prompt "Bluetooth")

case "$action" in
    "Connect to device") do_connect ;;
    "Disconnect") do_disconnect ;;
    "Forget device") do_forget ;;
    "Toggle Bluetooth power") do_toggle_power ;;
    *) exit 0 ;;
esac
