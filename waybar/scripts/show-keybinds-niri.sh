#!/usr/bin/env bash
# show-keybinds-niri.sh — niri keybindings reference

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
    printf "\033[1;35m    ║             NIRI  KEYBINDINGS                  ║\033[0m\n"
    printf "\033[1;35m    ╚════════════════════════════════════════════════╝\033[0m\n"

    header "Launch"
    row "Super + Enter"            "Terminal (alacritty)"
    row "Super + D"                "App launcher (wofi)"
    row "Super + Shift + F"        "Files (Nautilus)"
    row "Super + Shift + B"        "Browser (Firefox)"
    row "Super + Q"                "Close window"
    row "Super + Shift + E"        "Exit niri (confirm)"

    header "Focus"
    row "Super + H / L"            "Focus column  ←  →"
    row "Super + J / K"            "Focus window in column  ↓  ↑"
    row "Super + Arrow keys"       "Same as above"

    header "Move"
    row "Super + Shift + H/L"      "Move column  ←  →"
    row "Super + Shift + J/K"      "Move window in column  ↓  ↑"
    row "Super + Shift + Arrows"   "Same as above"

    header "Workspaces"
    row "Super + 1–9, 0"           "Switch to workspace 1–10"
    row "Super + Shift + 1–9, 0"   "Move column to workspace 1–10"

    header "Layout  (no split-tree in niri)"
    row "Super + W"                "Toggle tabbed column display"
    row "Super + F"                "Fullscreen"
    row "Super + Shift + Space"    "Toggle floating"
    row "Super + Space"            "Focus toggle (tiling/floating)"
    row "Super + R"                "Cycle preset column width"
    row "Super + Shift + R"        "Cycle preset width (reverse)"
    row "Super + -/="               "Column width -10% / +10%"
    row "Super + Ctrl + -/="        "Window height -10% / +10%"

    header "Screenshots  (built into niri)"
    row "Print"                    "Full screen → ~/Pictures"
    row "Super + Print"            "Interactive select → ~/Pictures"
    row "Super + \`"                "Window screenshot → ~/Pictures"

    header "System"
    row "Super + Ctrl + L"         "Lock screen (matrix)"
    row "Super + Shift + P"        "Power menu (lock/sleep/restart/shutdown/logout)"
    row "XF86MonBrightnessUp/Down" "Brightness ±10%"
    row "XF86AudioRaiseVolume"     "Volume +5%"
    row "XF86AudioLowerVolume"     "Volume -5%"
    row "XF86AudioMute"            "Toggle mute"
    row "XF86AudioMicMute"         "Toggle mic mute"

    header "Not carried over from sway"
    row "splith / splitv"          "no split-tree in niri"
    row "layout stacking"          "no split-tree in niri"
    row "focus parent"             "no parent containers in niri"
    row "scratchpad"               "not available in niri"

    echo ""
    printf "\033[38;5;240m    scroll or arrows to navigate · q to close\033[0m\n"
    echo ""
}

show_binds | less -R --prompt="" -K --mouse
