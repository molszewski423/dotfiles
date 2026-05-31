# dotfiles

Complete Wayland desktop configuration for Debian 13 (MikeInspiron  -  Dell Inspiron).
Clone this repo on a new machine and run `install.sh` to replicate the setup.

## Quick setup

```bash
git clone https://gitlab.com/molszewski423/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

## Contents

| Path | Description |
|---|---|
| `hypr/` | Hyprland compositor + hyprlock + hypridle + hyprpaper |
| `waybar/` | Status bar config + scripts (wifi, volume, power, keybinds) |
| `mako/` | Wayland notification daemon |
| `wofi/` | App launcher |
| `kitty/` | Terminal emulator |
| `fish/` | Fish shell config and functions |
| `niri/` | Niri compositor (alternative to Hyprland) |
| `sway/` | Sway compositor |
| `foot/` | Foot terminal |
| `ly/` | ly display manager config (copy to /etc/ly/config.ini) |
| `bin/` | Helper scripts (screenshot with grim + slurp + wl-clipboard) |
| `packages.txt` | Full apt package list |
| `install.sh` | One-shot setup script |

## Desktop stack

- **Display manager:** ly (built from source)
- **Compositor:** Hyprland 0.55.2
- **Bar:** Waybar
- **Notifications:** Mako
- **Launcher:** Wofi
- **Terminal:** Kitty
- **Shell:** Fish 4.0
- **Audio:** Pipewire + Wireplumber
- **Screenshots:** grim + slurp → clipboard via wl-copy

## Keybindings

| Key | Action |
|---|---|
| Super+Return | Terminal (kitty) |
| Super+D | App launcher (wofi) |
| Super+Q | Close window |
| Super+S | Full screenshot |
| Super+Shift+S | Active window screenshot |
| Super+Ctrl+L | Lock screen (hyprlock) |
| Super+H/J/K/L | Focus (vim keys) |
| Super+Shift+H/J/K/L | Move window |
| Super+1-9 | Switch workspace |
| Super+F | Fullscreen |
| Super+R | Resize mode |

## Notes

- ly is not in Debian apt  -  build from https://github.com/fairyglade/ly
- Wallpapers stored in `~/Pictures/`  -  update `hypr/hyprpaper.conf` for your files
- ThinkPad may need `kb_options` adjustment in `hypr/hyprland.conf` for keyboard layout
