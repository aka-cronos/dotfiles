#!/usr/bin/env bash
# Config shared by the Mac and the PC: git, mise, shell aliases and agents.
# Usage: shared/install.sh <mac|omarchy>  (called by mac/bootstrap.sh and
# omarchy/install.sh). Idempotent; portable to macOS's bash 3.2.
set -euo pipefail

MACHINE="${1:?usage: shared/install.sh <mac|omarchy>}"
SHARED_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SHARED_DIR")"
# shellcheck source=shared/lib.sh
source "$SHARED_DIR/lib.sh"

# ---------------------------------------------------------------------------
# 1. Git (shared config + this machine's signing setup)
# ---------------------------------------------------------------------------
link_file "$SHARED_DIR/git/gitconfig" "$HOME/.config/git/config"
link_file "$SHARED_DIR/git/ignore" "$HOME/.config/git/ignore"
link_file "$SHARED_DIR/git/allowed_signers" "$HOME/.config/git/allowed_signers"
link_file "$DOTFILES_DIR/$MACHINE/git/machine" "$HOME/.config/git/machine"

# ~/.gitconfig would override ~/.config/git/config: move it out of the way.
if [[ -L "$HOME/.gitconfig" ]]; then
  rm "$HOME/.gitconfig"
elif [[ -e "$HOME/.gitconfig" ]]; then
  backup_path "$HOME/.gitconfig"
fi

# ---------------------------------------------------------------------------
# 2. Toolchain (mise: node, pnpm, gh, claude, codex, cursor-agent)
# ---------------------------------------------------------------------------
link_file "$SHARED_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"

if command -v mise >/dev/null 2>&1; then
  log "Installing mise-managed tools..."
  mise install -y
  export PATH="$HOME/.local/share/mise/shims:$PATH"
else
  log "mise not found: skipping tools"
fi

# ---------------------------------------------------------------------------
# 3. Shell aliases (sourced by zsh on the Mac and bash on the PC)
# ---------------------------------------------------------------------------
link_file "$SHARED_DIR/shell/aliases.sh" "$HOME/.config/shell/aliases.sh"

# ---------------------------------------------------------------------------
# 4. Coding agents (rules, Claude Code settings, global skills)
# ---------------------------------------------------------------------------
log "Setting up coding agents..."
"$SHARED_DIR/agents/install.sh"
