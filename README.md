# dotfiles

Wayland desktop configuration for **MikeThinkPad** (T14 Gen 2i, Rocky Linux 10.2, Sway + GNOME via GDM). Clone and run `install-rocky.sh` to replicate the setup on a new Rocky install.

This repo used to be shared with a Dell Inspiron running Debian 13 + Hyprland. That machine has since been wiped and repurposed as **centosbook** — a CentOS Stream 10 k3s worker — and no longer uses this repo at all. The old Debian/Hyprland material (`hypr/`, `niri/`, `ly/`, `sway-inspiron/`, `packages.txt`, `install.sh`) is kept for history but is not maintained and doesn't reflect any machine currently in use.

## Why Rocky Linux, not Debian

Every other machine in the homelab runs Debian (MikePC, debianbox) except centosbook, kept deliberately on CentOS Stream for remote/server-side RHEL exposure. The ThinkPad was switched from Debian to Rocky on top of that for a different, complementary reason: **desktop-level RHEL experience** — living in `dnf`, SELinux, `authselect`, and EPEL/COPR package sourcing day to day, not just administering a RHEL box over SSH. That's a distinct skill set from centosbook's headless server exposure and directly supports the platform/DevOps/solutions-architecture job search (alongside the AWS SAA → CKA certification path).

It's also a deliberate choice of the harder path: Rocky 10 / EPEL10 is young enough that a real chunk of the desktop stack isn't packaged yet (see below), which forces exactly the kind of package-management/troubleshooting reps that make the RHEL experience real rather than superficial.

## Quick setup

```bash
git clone http://git.lan/mike/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install-rocky.sh
```

`install-rocky.sh` handles everything dnf/COPR can install and the config symlinking. It prints manual steps at the end for the pieces that have no el10 package anywhere (see below) — those aren't scripted because they involve real judgment calls (matching a source build to the exact installed library version, verifying checksums), not because it was skipped out of laziness.

## Contents

| Path | Description |
|---|---|
| `sway/` | Sway compositor config + scripts (wifi menu, bluetooth menu, idle actions) |
| `waybar/` | Status bar config + scripts (wifi, volume, power, keybinds) |
| `wofi/` | App launcher |
| `kitty/` | Terminal emulator config (binary is self-contained, see below) |
| `foot/` | Foot terminal (fallback/lightweight terminal) |
| `fish/` | Fish shell config and functions |
| `systemd/user/` | User services: `gsd-rfkill` + `polkit-kde-authentication-agent-1` (systemd-managed so they can't leak into an abandoned logind session on logout — see git history), `gstreamer-abi-watch.path`/`.service` (ABI-drift monitor, see below) |
| `scripts/check-gstreamer-abi.sh` | Warns if `gstreamer1-plugins-base` drifts from the version the hand-built ffmpeg/gst-libav plugin was compiled against |
| `bin/` | Helper scripts (screenshot with grim + slurp + wl-clipboard) |
| `packages-rocky.txt` | Rocky/dnf package list, with COPR sources and source-build items called out |
| `install-rocky.sh` | Setup script for Rocky Linux |
| `hypr/`, `niri/`, `ly/`, `sway-inspiron/`, `packages.txt`, `install.sh` | **Legacy** — the old MikeInspiron/Debian/Hyprland setup, superseded, kept for reference only |

## Desktop stack

- **Display/session manager:** GDM (offers both `sway.desktop` and `gnome.desktop`/`gnome-wayland.desktop`)
- **Compositor:** Sway (GNOME available as a fallback session)
- **Bar:** Waybar (built from source — no el10 package exists)
- **Notifications:** Mako (built from source)
- **Launcher:** Wofi (via `yselkowitz/wlroots-epel` COPR)
- **Terminal:** kitty (installed via its own official installer, not packaged)
- **Shell:** Fish
- **Bluetooth:** gnome-bluetooth (substitute — `blueman` has no el10 package)
- **Polkit agent:** polkit-kde (substitute — `lxpolkit` has no el10 package)
- **Fingerprint:** fprintd/fprintd-pam (Synaptics Prometheus reader, IS in Rocky's base AppStream repo)

## Packages with no Rocky 10 / EPEL10 equivalent (as of 2026-08)

Rocky 10 is a young release and the desktop/Wayland ecosystem hasn't fully caught up in EPEL10 yet. These required workarounds — see `packages-rocky.txt` for the exact COPR repos and `reference_epel10_wayland_copr` notes for how they were verified (COPR "package exists" search results are unreliable; only a chroot with a successful `epel-10-x86_64` build actually works):

- **waybar, mako** — no el10 package anywhere, built from source via meson/ninja
- **kitty** — no working el10 RPM, installed via kitty's own self-contained installer
- **JetBrainsMono Nerd Font** — no COPR/RPM with the patched glyphs, installed from the upstream nerd-fonts GitHub release
- **ffmpeg + gst-libav** — no working RPM Fusion or COPR build for el10; built from source (7.1.5 / 1.26.7) to restore HLS (`.m3u8`) video playback in native Firefox, since Rocky's base GStreamer only ships the patent-restricted-free plugin set. This one is the real risk: it has no dnf tracking, so a `dnf update` that bumps `gstreamer1-plugins-base` can silently break it. `scripts/check-gstreamer-abi.sh` runs automatically after every rpm transaction (via the `gstreamer-abi-watch.path` systemd unit) and fires a desktop notification if the installed version drifts from what the build was matched against — check `~/src/ffmpeg-7.1.5` / `~/src/gst-libav-1.26.7` for the rebuild if it fires.
- **TLP** — not packaged for el10; `tuned`'s `[sysfs]` plugin substitutes for charge-threshold management (PCIe ASPM tuning is a firmware-level no-op on this hardware regardless of OS)
- **blueman, lxpolkit** — substituted with `gnome-bluetooth` and `polkit-kde` respectively

## Notes

- Fingerprint auth (login, sudo, swaylock) uses a custom `authselect` profile (`custom/thinkpad-fprint`) rather than the stock `local` profile, since `local` doesn't implement switchable (password-or-fingerprint) authentication at all on Rocky — not scripted in `install-rocky.sh`, needs to be recreated by hand if this machine is ever reinstalled.
- GDM fingerprint login (as opposed to swaylock/sudo, which both work) is a known open issue — low priority, not being actively pursued.
- HDMI port has a pixelation issue (hardware, not driver) — use the USB-C port for an external monitor.
