#!/usr/bin/env bash
# MikeThinkPad dotfiles install script — Rocky Linux 10.2
# Sets up a fresh Rocky install to match MikeThinkPad's Sway+GNOME desktop.
# Usage: bash install-rocky.sh
#
# Unlike install.sh (MikeInspiron/Debian, now historical — see README), this can't be
# a single package-manager pass: several pieces have no el10 package anywhere yet and
# must be built from source or installed via their own official installer. Those steps
# are printed at the end rather than automated, since they involve manual verification
# (checksums, matching the installed gstreamer1 version, etc.) — see packages-rocky.txt
# and reference/epel10-copr-notes.md for why.

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Enabling COPR repos..."
sudo dnf copr enable -y @sway-sig/epel
sudo dnf copr enable -y yselkowitz/wlroots-epel

echo "==> Installing dnf-available packages..."
sudo dnf install -y \
    sway swaybg swayidle swaylock slurp grim kanshi \
    wofi brightnessctl playerctl xdg-desktop-portal-wlr foot gtk-layer-shell \
    gnome-bluetooth polkit-kde fprintd fprintd-pam \
    libvirt-daemon-config-network libvirt-daemon-driver-qemu virt-manager \
    jetbrains-mono-fonts papirus-icon-theme tuned

echo "==> Linking configs..."
mkdir -p ~/.config/sway/scripts ~/.config/waybar/scripts ~/.config/mako \
         ~/.config/wofi ~/.config/kitty ~/.config/fish/conf.d \
         ~/.config/fish/functions ~/.config/foot ~/.config/systemd/user \
         ~/.local/bin

cp "$DOTFILES_DIR/sway/config" ~/.config/sway/
cp "$DOTFILES_DIR/sway/scripts/"* ~/.config/sway/scripts/
chmod +x ~/.config/sway/scripts/*.sh

cp "$DOTFILES_DIR/waybar/config-common.jsonc" ~/.config/waybar/
cp "$DOTFILES_DIR/waybar/config-sway.jsonc" ~/.config/waybar/
cp "$DOTFILES_DIR/waybar/style.css" ~/.config/waybar/
cp "$DOTFILES_DIR/waybar/scripts/"* ~/.config/waybar/scripts/
chmod +x ~/.config/waybar/scripts/*.sh

cp "$DOTFILES_DIR/wofi/"* ~/.config/wofi/
cp "$DOTFILES_DIR/kitty/kitty.conf" ~/.config/kitty/
cp "$DOTFILES_DIR/foot/foot.ini" ~/.config/foot/

# GUI launchers (wofi/GDM) get a minimal environment and skip shell profile
# sourcing, so any app needing PATH/LD_LIBRARY_PATH fixes needs a user-level
# .desktop override pointing at an absolute-path wrapper script instead.
mkdir -p ~/.local/share/applications
cp "$DOTFILES_DIR/desktop-overrides/"*.desktop ~/.local/share/applications/
update-desktop-database ~/.local/share/applications 2>/dev/null || true

cp "$DOTFILES_DIR/fish/config.fish" ~/.config/fish/
cp "$DOTFILES_DIR/fish/conf.d/"* ~/.config/fish/conf.d/ 2>/dev/null || true
cp "$DOTFILES_DIR/fish/functions/"* ~/.config/fish/functions/ 2>/dev/null || true

cp "$DOTFILES_DIR/systemd/user/"* ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user start gsd-rfkill.service polkit-kde-authentication-agent-1.service

cp "$DOTFILES_DIR/bin/screenshot.sh" ~/.local/bin/
chmod +x ~/.local/bin/screenshot.sh

cp "$DOTFILES_DIR/scripts/check-gstreamer-abi.sh" ~/.local/bin/
chmod +x ~/.local/bin/check-gstreamer-abi.sh
~/.local/bin/check-gstreamer-abi.sh --record
systemctl --user enable --now gstreamer-abi-watch.path

echo "==> Enabling fingerprint auth..."
sudo authselect enable-feature with-fingerprint || true

echo ""
echo "==> Manual steps still required (no el10 package exists for these):"
echo "    1. waybar  - build from source, meson setup with -Dmpd=disabled,"
echo "                 needs systemd-devel for the battery module (libudev.h)"
echo "    2. mako    - build from source via meson"
echo "    3. kitty   - curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"
echo "    4. Nerd Font - download JetBrainsMono Nerd Font from the nerd-fonts GitHub"
echo "                    releases into ~/.local/share/fonts/ (plain jetbrains-mono-fonts"
echo "                    has no glyphs — everything will render as tofu without this)"
echo "    5. ffmpeg + gst-libav - build from source, matched EXACTLY to the installed"
echo "                            gstreamer1 version, if native Firefox needs to play"
echo "                            HLS (.m3u8) video (e.g. Udemy). See"
echo "                            scripts/check-gstreamer-abi.sh once built."
echo "    6. Firefox - add Mozilla's own repo (packages.mozilla.org/rpm/firefox),"
echo "                 repo_gpgcheck=0 is required (Mozilla's repomd.xml.asc key"
echo "                 doesn't match their published signing key, package-level"
echo "                 gpgcheck=1 still applies and is what actually matters)"
echo ""
echo "==> Done. Log out and select Sway or GNOME from GDM."
