#!/usr/bin/env bash
# ThinkPad (Fedora 45) desktop: per-user GNOME settings (run as mike, not root), 2026-10-02.
set -euo pipefail
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
