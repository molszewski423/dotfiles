#!/usr/bin/env bash
# volume-menu.sh — comprehensive audio controls via wofi

# ── Output (sink) ─────────────────────────────────────────────
sink_raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
sink_pct=$(awk '{printf "%d", $2 * 100}' <<< "$sink_raw")
sink_muted=$(grep -c MUTED <<< "$sink_raw")

if (( sink_pct >= 75 )); then bar="▂▄▆█"
elif (( sink_pct >= 50 )); then bar="▂▄▆_"
elif (( sink_pct >= 25 )); then bar="▂▄__"
else                            bar="▂___"; fi

if (( sink_muted )); then
    out_status="󰖁  Output: MUTED  (${sink_pct}%)"
    mute_out="󰕾  Unmute output"
else
    out_status="󰕾  Output: ${sink_pct}%  ${bar}"
    mute_out="󰖁  Mute output"
fi

# ── Input (source / mic) ──────────────────────────────────────
mic_raw=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)
mic_pct=$(awk '{printf "%d", $2 * 100}' <<< "$mic_raw")
mic_muted=$(grep -c MUTED <<< "$mic_raw")

if (( mic_muted )); then
    mic_status="󰍭  Mic: MUTED  (${mic_pct}%)"
    mute_mic="󰍬  Unmute mic"
else
    mic_status="󰍬  Mic: ${mic_pct}%"
    mute_mic="󰍭  Mute mic"
fi

entries=(
    "$out_status"
    "$mute_out"
    "   Volume +10%"
    "   Volume -10%"
    "   Volume +5%"
    "   Volume -5%"
    "󰕾  Set 100%"
    "󰖀  Set  75%"
    "󰕿  Set  50%"
    "󰕿  Set  25%"
    "──────────────────────────────"
    "$mic_status"
    "$mute_mic"
    "   Mic +10%"
    "   Mic -10%"
)

chosen=$(printf '%s\n' "${entries[@]}" | wofi --dmenu \
    --conf /home/mike/.config/wofi/volume.conf \
    --cache-file /dev/null)

[[ -z "$chosen" || "$chosen" == ──* ]] && exit 0

refresh() { pkill -RTMIN+8 waybar; }

case "$chosen" in
    *"Output:"*|*"Mic:"*) ;;
    *"Mute output"|*"Unmute output")
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; refresh ;;
    *"Volume +10%")
        wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 10%+; refresh ;;
    *"Volume -10%")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-; refresh ;;
    *"Volume +5%")
        wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+; refresh ;;
    *"Volume -5%")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-; refresh ;;
    *"Set 100%")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0; refresh ;;
    *"Set  75%")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.75; refresh ;;
    *"Set  50%")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.50; refresh ;;
    *"Set  25%")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.25; refresh ;;
    *"Mute mic"|*"Unmute mic")
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
    *"Mic +10%")
        wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 10%+ ;;
    *"Mic -10%")
        wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 10%- ;;
esac
