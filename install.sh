#!/usr/bin/env bash
# MikeInspiron dotfiles install script
# Sets up a fresh Debian 13 machine identically to MikeInspiron
# Usage: bash install.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Installing packages..."
grep -v '^\s*#' "$DOTFILES_DIR/packages.txt" | grep -v '^\s*$' | xargs sudo apt install -y

echo "==> Linking configs..."
mkdir -p ~/.config/hypr ~/.config/waybar/scripts ~/.config/mako \
         ~/.config/wofi ~/.config/kitty ~/.config/fish/conf.d \
         ~/.config/fish/functions ~/.config/niri ~/.config/sway \
         ~/.config/foot ~/.local/bin

# Hyprland
cp "$DOTFILES_DIR/hypr/"* ~/.config/hypr/
chmod +x ~/.config/hypr/idle.sh

# Waybar
cp "$DOTFILES_DIR/waybar/config.jsonc" ~/.config/waybar/
cp "$DOTFILES_DIR/waybar/style.css" ~/.config/waybar/
cp "$DOTFILES_DIR/waybar/scripts/"* ~/.config/waybar/scripts/
chmod +x ~/.config/waybar/scripts/*.sh

# Mako
cp "$DOTFILES_DIR/mako/config" ~/.config/mako/

# Wofi
cp "$DOTFILES_DIR/wofi/"* ~/.config/wofi/

# Kitty
cp "$DOTFILES_DIR/kitty/kitty.conf" ~/.config/kitty/

# Fish
cp "$DOTFILES_DIR/fish/config.fish" ~/.config/fish/
cp "$DOTFILES_DIR/fish/conf.d/"* ~/.config/fish/conf.d/ 2>/dev/null || true
cp "$DOTFILES_DIR/fish/functions/"* ~/.config/fish/functions/ 2>/dev/null || true

# Niri
cp "$DOTFILES_DIR/niri/config.kdl" ~/.config/niri/
cp "$DOTFILES_DIR/niri/lock.sh" ~/.config/niri/
chmod +x ~/.config/niri/lock.sh

# Sway
cp "$DOTFILES_DIR/sway/config" ~/.config/sway/

# Foot
cp "$DOTFILES_DIR/foot/foot.ini" ~/.config/foot/

# Scripts
cp "$DOTFILES_DIR/bin/screenshot.sh" ~/.local/bin/
chmod +x ~/.local/bin/screenshot.sh

echo "==> Installing ly login manager..."
echo "    ly is not in apt — build from source:"
echo "    https://github.com/fairyglade/ly"
echo "    Then copy ly/config.ini to /etc/ly/config.ini"
echo ""
echo "==> Done. Log out and select Hyprland from ly."
