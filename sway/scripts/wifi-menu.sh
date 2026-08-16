#!/bin/bash
# Wi-Fi menu for Sway: wofi + nmcli. Connect / disconnect / forget / toggle radio.
set -euo pipefail

notify() { notify-send "Wi-Fi" "$1"; }

list_networks() {
    nmcli -t -f SSID,SECURITY,SIGNAL,IN-USE dev wifi list --rescan yes \
        | awk -F: '$1 != ""' \
        | sort -t: -k3,3 -rn \
        | awk -F: '!seen[$1]++'
}

do_connect() {
    local networks menu choice ssid line security pass
    networks=$(list_networks)
    if [ -z "$networks" ]; then
        notify "No networks found"
        return
    fi

    menu=$(echo "$networks" | awk -F: '{mark=($4=="*")?" (connected)":""; print $1 mark}')
    choice=$(echo "$menu" | wofi --dmenu --prompt "Wi-Fi networks")
    [ -z "$choice" ] && return

    ssid="${choice% (connected)}"
    line=$(echo "$networks" | awk -F: -v s="$ssid" '$1==s {print; exit}')
    security=$(echo "$line" | cut -d: -f2)

    if [ -z "$security" ] || [ "$security" = "--" ]; then
        if nmcli dev wifi connect "$ssid" 2>/tmp/wifi-menu-err; then
            notify "Connected to $ssid"
        else
            notify "Failed to connect to $ssid: $(cat /tmp/wifi-menu-err)"
        fi
    else
        notify "Enter password for $ssid, then press Enter"
        pass=$(wofi --dmenu --password --prompt "Password for $ssid")
        [ -z "$pass" ] && return
        if nmcli dev wifi connect "$ssid" password "$pass" 2>/tmp/wifi-menu-err; then
            notify "Connected to $ssid"
        else
            notify "Failed to connect to $ssid: $(cat /tmp/wifi-menu-err)"
        fi
    fi
}

do_disconnect() {
    local dev
    dev=$(nmcli -t -f DEVICE,TYPE,STATE device status | awk -F: '$2=="wifi" && $3=="connected" {print $1; exit}')
    if [ -z "$dev" ]; then
        notify "No active Wi-Fi connection"
        return
    fi
    if nmcli device disconnect "$dev" 2>/tmp/wifi-menu-err; then
        notify "Disconnected"
    else
        notify "Failed to disconnect: $(cat /tmp/wifi-menu-err)"
    fi
}

do_forget() {
    local saved choice
    saved=$(nmcli -t -f NAME,TYPE connection show | awk -F: '$2=="802-11-wireless" {print $1}')
    if [ -z "$saved" ]; then
        notify "No saved Wi-Fi networks"
        return
    fi
    choice=$(echo "$saved" | wofi --dmenu --prompt "Forget network")
    [ -z "$choice" ] && return
    if nmcli connection delete "$choice" 2>/tmp/wifi-menu-err; then
        notify "Forgot $choice"
    else
        notify "Failed to forget $choice: $(cat /tmp/wifi-menu-err)"
    fi
}

do_toggle_radio() {
    local state
    state=$(nmcli radio wifi)
    if [ "$state" = "enabled" ]; then
        nmcli radio wifi off
        notify "Wi-Fi radio off"
    else
        nmcli radio wifi on
        notify "Wi-Fi radio on"
    fi
}

action=$(printf '%s\n' "Connect to network" "Disconnect" "Forget network" "Toggle Wi-Fi radio" \
    | wofi --dmenu --prompt "Wi-Fi")

case "$action" in
    "Connect to network") do_connect ;;
    "Disconnect") do_disconnect ;;
    "Forget network") do_forget ;;
    "Toggle Wi-Fi radio") do_toggle_radio ;;
    *) exit 0 ;;
esac
