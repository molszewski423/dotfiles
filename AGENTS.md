# dotfiles: agent instructions

Read the global agent instructions first: `~/.claude/CLAUDE.md` (Claude Code) or `~/.codex/AGENTS.md` (Codex),
both linked to `context/global/AGENTS.md` in the private claude-memory repo. They cover conventions, approvals and
the session protocol (branches `<agent>/<topic>`, signed commits with an `Agent:` trailer, handoff notes). This file
adds what is specific to this repository; where it is stricter, it wins.

## What this is

Desktop configuration for the ThinkPad (dev-laptop-2): Fedora 45 now (`install-fedora.sh`,
`gnome-desktop-root.sh`, `gnome-desktop-user.sh`), with the earlier Rocky material kept for reference. See `README.md`.

## Rules for this repository

- **Public on Gitea.** No secrets, tokens, Wi-Fi details or host-specific addresses in config.
- Root steps go in the `*-root.sh` scripts the owner runs; agents do not run sudo.
