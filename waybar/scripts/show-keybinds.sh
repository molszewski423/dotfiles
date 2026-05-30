#!/usr/bin/env bash
# show-keybinds.sh — Hyprland keybindings reference

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
    printf "\033[1;35m    ║           HYPRLAND  KEYBINDINGS                ║\033[0m\n"
    printf "\033[1;35m    ╚════════════════════════════════════════════════╝\033[0m\n"

    header "Launch"
    row "Super + Enter"            "Terminal (kitty)"
    row "Super + D"                "App launcher (wofi)"
    row "Super + Shift + F"        "Files (Nautilus)"
    row "Super + Shift + B"        "Browser (Brave)"
    row "Super + Q"                "Kill window"
    row "Super + Shift + C"        "Reload config"
    row "Super + Shift + E"        "Exit Hyprland"

    header "Focus"
    row "Super + H / J / K / L"   "Focus  ←  ↓  ↑  →"
    row "Super + Arrow keys"       "Focus  ←  ↓  ↑  →"

    header "Move"
    row "Super + Shift + H/J/K/L"  "Move window  ←  ↓  ↑  →"
    row "Super + Shift + Arrows"   "Move window  ←  ↓  ↑  →"

    header "Workspaces"
    row "Super + 1–9, 0"           "Switch to workspace 1–10"
    row "Super + Shift + 1–9, 0"   "Move window to workspace 1–10"

    header "Layout (dwindle)"
    row "Super + B"                "Preselect split right"
    row "Super + V"                "Preselect split down"
    row "Super + E"                "Toggle split direction"
    row "Super + F"                "Fullscreen"
    row "Super + Shift + Space"    "Toggle floating"
    row "Super + Space"            "Cycle to next window"

    header "Scratchpad"
    row "Super + Shift + -"        "Send to scratchpad"
    row "Super + -"                "Toggle scratchpad"

    header "Resize mode  (Super + R to enter)"
    row "H / J / K / L"           "Resize  ←  ↓  ↑  →  (20px)"
    row "Arrow keys"               "Same as above"
    row "Enter / Escape"           "Exit resize mode"

    header "Screenshots"
    row "Print"                    "Full screenshot → ~/Pictures"
    row "Super + Print"            "Area select → ~/Pictures"

    header "System"
    row "Super + Ctrl + L"         "Lock screen (hyprlock)"
    row "XF86MonBrightnessUp/Down" "Brightness ±10%"
    row "XF86AudioRaiseVolume"     "Volume +5%"
    row "XF86AudioLowerVolume"     "Volume -5%"
    row "XF86AudioMute"            "Toggle mute"
    row "XF86AudioMicMute"         "Toggle mic mute"

    echo ""
    printf "\033[38;5;240m    scroll or arrows to navigate · q to close\033[0m\n"
    echo ""
}

show_binds | less -R --prompt="" -K --mouse
