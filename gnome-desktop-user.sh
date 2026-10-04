#!/usr/bin/env bash
# ThinkPad (Fedora 45) desktop: per-user GNOME settings (run as mike, not root), 2026-10-02.
set -euo pipefail
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
# Clipboard history (clipboard-indicator): memory only except pinned favorites, small, never auto-cleared.
# Timed clearing is a LocumView VDI control (Clipboard Guard, changelog #26), not wanted on this laptop; copy-out
# from the VDI is blocked, so desktop content doesn't reach this clipboard.
CI=~/.local/share/gnome-shell/extensions/clipboard-indicator@tudmotu.com/schemas
if [ -d "$CI" ]; then
  ci() { gsettings --schemadir "$CI" set org.gnome.shell.extensions.clipboard-indicator "$@"; }
  ci cache-only-favorites true; ci cache-images false; ci history-size 10
  ci clear-on-boot false; ci clear-history-on-interval false
fi
