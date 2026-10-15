#!/usr/bin/env bash
# Desktop PC (Omarchy) setup: the steps that run as the user. Steps that need
# sudo, packages and sign-ins stay in README.md. Run from a clone of this repo.
# Idempotent: safe to run as many times as needed.
set -euo pipefail

OMARCHY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$OMARCHY_DIR")"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"

log() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

link_file() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [[ -e "$dst" && ! -L "$dst" ]]; then
    log "Backing up $dst -> $BACKUP_DIR/"
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/"
  fi

  ln -sfn "$src" "$dst"
  log "Symlink: $dst -> $src"
}

# ---------------------------------------------------------------------------
# 1. Git signing key (on disk, so agents can sign while nobody is at the desk)
# ---------------------------------------------------------------------------
SIGNING_KEY="$HOME/.ssh/git_signing_ed25519"
if [[ ! -f "$SIGNING_KEY" ]]; then
  log "Creating git signing key: $SIGNING_KEY"
  mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
  ssh-keygen -q -t ed25519 -N "" -C "git signing (cronos-pc)" -f "$SIGNING_KEY"
  NEW_SIGNING_KEY=1
fi

# ---------------------------------------------------------------------------
# 2. Shared config: git, mise tools, shell aliases, coding agents
# ---------------------------------------------------------------------------
"$DOTFILES_DIR/shared/install.sh" omarchy

# ---------------------------------------------------------------------------
# 3. Shell: bash additions and prompt
# ---------------------------------------------------------------------------
link_file "$OMARCHY_DIR/shell/bashrc.sh" "$HOME/.config/shell/bashrc.sh"
link_file "$OMARCHY_DIR/shell/starship.toml" "$HOME/.config/starship.toml"

HOOK='[[ -f ~/.config/shell/bashrc.sh ]] && source ~/.config/shell/bashrc.sh'
if ! grep -qxF "$HOOK" "$HOME/.bashrc"; then
  log "Adding dotfiles hook to ~/.bashrc"
  printf '\n# dotfiles (omarchy/shell/bashrc.sh)\n%s\n' "$HOOK" >> "$HOME/.bashrc"
fi

# ---------------------------------------------------------------------------
# 4. Hyprland
# ---------------------------------------------------------------------------
link_file "$OMARCHY_DIR/hypr/looknfeel.lua" "$HOME/.config/hypr/looknfeel.lua"
link_file "$OMARCHY_DIR/hypr/monitors.lua" "$HOME/.config/hypr/monitors.lua"
if command -v hyprctl >/dev/null 2>&1 && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  hyprctl reload >/dev/null
fi

# ---------------------------------------------------------------------------
# 5. Cursor collector for the bar's agents panel
# ---------------------------------------------------------------------------
link_file "$OMARCHY_DIR/bin/omarchy-agent-usage-cursor" "$HOME/.local/bin/omarchy-agent-usage-cursor"
# systemd does not enable units that are symlinks into a repo: copy them.
mkdir -p "$HOME/.config/systemd/user"
install -m 644 "$OMARCHY_DIR"/systemd/omarchy-agent-usage-cursor.{service,timer} "$HOME/.config/systemd/user/"
systemctl --user daemon-reload
systemctl --user enable --now omarchy-agent-usage-cursor.timer

# ---------------------------------------------------------------------------
# 6. Manual steps
# ---------------------------------------------------------------------------
cat <<'EOF'

==> PC setup complete. Open a new terminal to load the shell changes.
    Steps that need sudo or a sign-in are in omarchy/README.md.
EOF

if [[ -n "${NEW_SIGNING_KEY:-}" ]]; then
  cat <<EOF

==> New git signing key. Add it on GitHub so commits from this PC show
    "Verified": Settings > SSH and GPG keys > New SSH key, Key type
    "Signing Key", and paste:

    $(cat "$SIGNING_KEY.pub")

EOF
fi
