#!/usr/bin/env bash
# ThinkPad (Fedora 45) desktop: root steps. Rebuilt from ~/lid-waybar-setup.sh (Rocky era), 2026-10-02.
set -euo pipefail

echo "== 1. Dash to Dock (fedora) + Blur my Shell 73 (updates-testing; no GNOME 51 build on extensions.gnome.org yet)"
dnf install -y gnome-shell-extension-dash-to-dock
dnf install -y --enablerepo=updates-testing gnome-shell-extension-blur-my-shell
grep -h '"shell-version"' -A8 /usr/share/gnome-shell/extensions/{dash-to-dock@micxgx.gmail.com,blur-my-shell@aunetx}/metadata.json | tr -d ' \n'; echo

echo "== 2. Lid-close toggle (default: suspend on lid close)"
mkdir -p /etc/systemd/logind.conf.d
[ -f /etc/systemd/logind.conf.d/99-lid.conf ] || printf '[Login]\nHandleLidSwitch=suspend\n' > /etc/systemd/logind.conf.d/99-lid.conf
cat > /usr/local/bin/lid-toggle <<'EOF'
#!/usr/bin/env bash
# Flip lid-close between suspend and ignore. Applied with HUP (live reload), never
# "systemctl restart systemd-logind": a restart drops the graphical session.
CONF=/etc/systemd/logind.conf.d/99-lid.conf
mkdir -p "$(dirname "$CONF")"
current=$(grep -oP 'HandleLidSwitch=\K.*' "$CONF" 2>/dev/null || true)
[ -z "$current" ] && current=suspend
if [ "$current" = ignore ]; then new=suspend; else new=ignore; fi
printf '[Login]\nHandleLidSwitch=%s\n' "$new" > "$CONF"
systemctl kill -s HUP systemd-logind
echo "$new"
EOF
chmod 755 /usr/local/bin/lid-toggle
echo 'mike ALL=(root) NOPASSWD: /usr/local/bin/lid-toggle' > /etc/sudoers.d/lid-toggle
chmod 440 /etc/sudoers.d/lid-toggle
visudo -cf /etc/sudoers.d/lid-toggle
restorecon -v /usr/local/bin/lid-toggle /etc/sudoers.d/lid-toggle /etc/systemd/logind.conf.d/99-lid.conf || true
systemctl kill -s HUP systemd-logind
echo "lid state: $(cat /etc/systemd/logind.conf.d/99-lid.conf | tr '\n' ' ')"
echo "== 3. Papirus violet folders"
bash "$(dirname "$(readlink -f "$0")")/papirus-violet-root.sh"
echo DONE
