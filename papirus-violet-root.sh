#!/usr/bin/env bash
# Papirus violet folders (Tokyo Night purple), 2026-10-02.
# papirus-folders isn't packaged in Fedora; bin/papirus-folders is upstream v1.14.0 (MIT).
# It rewrites symlinks under /usr/share/icons/Papirus*, which a papirus-icon-theme RPM
# update resets, so a dnf5 actions hook reapplies violet after every update.
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"

install -m 755 bin/papirus-folders /usr/local/bin/papirus-folders
dnf install -y libdnf5-plugin-actions
mkdir -p /etc/dnf/libdnf5-plugins/actions.d
echo 'post_transaction:papirus-icon-theme:in::/usr/local/bin/papirus-folders -o -C violet --theme Papirus-Dark' \
    > /etc/dnf/libdnf5-plugins/actions.d/papirus-violet.actions
restorecon -v /usr/local/bin/papirus-folders /etc/dnf/libdnf5-plugins/actions.d/papirus-violet.actions || true

/usr/local/bin/papirus-folders -C violet --theme Papirus-Dark
echo DONE
