#!/usr/bin/env bash
# MikeThinkPad dotfiles — Fedora 45 system-level setup (needs root).
# Replaces install-rocky.sh: on Fedora everything the Rocky setup had to COPR,
# source-build or hand-install (waybar, mako, kitty, ffmpeg/gst-libav, blueman)
# is packaged, so this is a single dnf pass plus a few vendor repos.
# User-level config deployment is done separately (no root needed).
# Usage: sudo bash install-fedora.sh

set -euo pipefail

[[ $EUID -eq 0 ]] || { echo "Run with sudo"; exit 1; }
TARGET_USER="${SUDO_USER:-mike}"

echo "==> Vendor repos (Tailscale, VSCodium, LibreWolf)..."
curl -fsSL https://pkgs.tailscale.com/stable/fedora/tailscale.repo -o /etc/yum.repos.d/tailscale.repo
curl -fsSL https://repo.librewolf.net/librewolf.repo -o /etc/yum.repos.d/librewolf.repo
rpm --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
cat > /etc/yum.repos.d/vscodium.repo <<'EOF'
[gitlab.com_paulcarroty_vscodium_repo]
name=download.vscodium.com
baseurl=https://download.vscodium.com/rpms/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
metadata_expire=1h
EOF

echo "==> RPM Fusion + full ffmpeg (replaces the hand-built ffmpeg/gst-libav for HLS/Udemy)..."
dnf install -y \
    "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
    "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
dnf swap -y ffmpeg-free ffmpeg --allowerasing
dnf install -y gstreamer1-plugin-libav gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly

echo "==> Desktop stack (Sway, GNOME stays as fallback session)..."
dnf install -y --skip-unavailable \
    sway swaybg swayidle swaylock slurp grim kanshi \
    waybar mako wofi kitty foot \
    brightnessctl playerctl xdg-desktop-portal-wlr gtk-layer-shell \
    wl-clipboard cliphist jq libnotify mpvpaper \
    polkit-kde blueman fprintd fprintd-pam \
    jetbrains-mono-fonts-all papirus-icon-theme \
    fish fastfetch \
    evolution chromium librewolf codium \
    golang rustup nodejs npm awscli2 kubernetes-client \
    qemu-kvm libvirt-daemon-kvm libvirt-daemon-config-network virt-manager \
    tailscale

echo "==> Starship prompt (not packaged in Fedora; --skip-unavailable used to drop it silently)..."
SS_TAG=$(curl -fsSL https://api.github.com/repos/starship/starship/releases/latest | python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"])')
SS_TMP=$(mktemp -d)
SS_F=starship-x86_64-unknown-linux-musl.tar.gz
curl -fsSL -o "$SS_TMP/$SS_F" "https://github.com/starship/starship/releases/download/$SS_TAG/$SS_F"
curl -fsSL -o "$SS_TMP/$SS_F.sha256" "https://github.com/starship/starship/releases/download/$SS_TAG/$SS_F.sha256"
(cd "$SS_TMP" && echo "$(cat "$SS_F.sha256")  $SS_F" | sha256sum -c -)
tar xzf "$SS_TMP/$SS_F" -C "$SS_TMP" && install -m 755 "$SS_TMP/starship" /usr/local/bin/starship
rm -rf "$SS_TMP"

echo "==> Services..."
systemctl enable --now tailscaled
systemctl enable --now libvirtd.socket 2>/dev/null || systemctl enable --now virtqemud.socket
authselect enable-feature with-fingerprint || true

echo "==> Flatpaks (Boxes was a Flatpak on Rocky — VM data is already restored to ~/.var/app)..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --no-filter --enable flathub || true
flatpak install -y flathub org.gnome.Boxes org.libreoffice.LibreOffice

echo "==> Default shell -> fish for $TARGET_USER..."
usermod -s /usr/bin/fish "$TARGET_USER"

echo ""
echo "==> Done. Remaining manual step: sudo tailscale up"
echo "    Then log out and pick Sway (or GNOME) from GDM's gear menu."
