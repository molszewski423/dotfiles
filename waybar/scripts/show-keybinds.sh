#!/usr/bin/env bash
# show-keybinds.sh — Display sway keybindings in a floating kitty terminal

show_binds() {
    header() {
        echo ""
        printf "\033[1;34m  %-56s\033[0m\n" "  $1"
        printf "\033[38;5;240m  %s\033[0m\n" "────────────────────────────────────────────────────"
    }
    row() {
        printf "    \033[1;36m%-30s\033[0m\033[38;5;250m%s\033[0m\n" "$1" "$2"
    }

    clear
    echo ""
    printf "\033[1;35m    ╔════════════════════════════════════════════════╗\033[0m\n"
    printf "\033[1;35m    ║              SWAY  KEYBINDINGS                 ║\033[0m\n"
    printf "\033[1;35m    ╚════════════════════════════════════════════════╝\033[0m\n"

    header "General"
    row "Super + Enter"            "Terminal (kitty)"
    row "Super + Shift + F"        "Files (Thunar)"
    row "Super + D"                "App launcher (wofi)"
    row "Super + Q"                "Kill window"
    row "Super + Shift + C"        "Reload config"
    row "Super + Shift + E"        "Exit sway"

    header "Focus"
    row "Super + H / J / K / L"   "Focus  ←  ↓  ↑  →"
    row "Super + Arrow keys"       "Focus  ←  ↓  ↑  →"

    header "Move"
    row "Super + Shift + H/J/K/L"  "Move window  ←  ↓  ↑  →"
    row "Super + Shift + Arrows"   "Move window  ←  ↓  ↑  →"

    header "Workspaces"
    row "Super + 1–9, 0"           "Switch to workspace 1–10"
    row "Super + Shift + 1–9, 0"   "Move window to workspace"

    header "Layout"
    row "Super + B"                "Split horizontal"
    row "Super + V"                "Split vertical"
    row "Super + S"                "Stacking layout"
    row "Super + W"                "Tabbed layout"
    row "Super + E"                "Toggle split"
    row "Super + F"                "Fullscreen"
    row "Super + Shift + Space"    "Toggle floating"
    row "Super + Space"            "Toggle focus (float ↔ tile)"
    row "Super + A"                "Focus parent"

    header "Scratchpad"
    row "Super + Shift + -"        "Send to scratchpad"
    row "Super + -"                "Show scratchpad"

    header "Resize mode  (Super + R to enter)"
    row "H / L"                    "Shrink / grow width  20px"
    row "J / K"                    "Grow / shrink height 20px"
    row "Arrow keys"               "Same as above"
    row "Enter / Escape"           "Exit resize mode"

    header "Screenshots"
    row "Print"                    "Full screenshot → ~/Pictures"
    row "Super + Print"            "Area select → ~/Pictures"

    header "System"
    row "Super + Ctrl + L"         "Lock screen"
    row "F11"                      "Lock screen"
    row "F6 / BrightnessDown"      "Brightness -10%"
    row "F7 / BrightnessUp"        "Brightness +10%"
    row "F8 / Mute key"            "Toggle mute"
    row "F9 / VolumeDown"          "Volume -5%"
    row "F10 / VolumeUp"           "Volume +5%"

    echo ""
    printf "\033[38;5;240m    scroll or arrows to navigate · q to close\033[0m\n"
    echo ""
}

show_binds | less -R --prompt="" -K --mouse
