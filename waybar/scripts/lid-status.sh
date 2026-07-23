#!/usr/bin/env bash
CONF=/etc/systemd/logind.conf.d/99-lid.conf
current=$(grep -oP 'HandleLidSwitch=\K.*' "$CONF" 2>/dev/null)
[ -z "$current" ] && current="suspend"

if [ "$current" = "ignore" ]; then
    printf '{"text":"󰒳","tooltip":"Lid: do nothing on close","class":"lid-ignore"}\n'
else
    printf '{"text":"󰒲","tooltip":"Lid: sleep on close","class":"lid-suspend"}\n'
fi
