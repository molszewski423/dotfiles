#!/usr/bin/env bash
set -euo pipefail

if makoctl mode | grep -qx "do-not-disturb"; then
    echo '{"text":"󰂛","tooltip":"Do Not Disturb is ON — click to re-enable notifications","class":"dnd"}'
else
    echo '{"text":"󰂚","tooltip":"Notifications enabled — click to enable Do Not Disturb","class":"active"}'
fi
