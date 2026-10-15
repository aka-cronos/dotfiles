#!/usr/bin/env bash
# Bootstrap for a new Mac (or to re-sync an already configured one).
# Idempotent: safe to run as many times as needed.
set -euo pipefail

MAC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$MAC_DIR")"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"

log() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

# ---------------------------------------------------------------------------
# 1. Homebrew
# ---------------------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ---------------------------------------------------------------------------
# 2. Brewfile (apps, fonts and base CLIs; dev tools come from mise)
# ---------------------------------------------------------------------------
log "Installing Brewfile packages..."
brew bundle --file="$MAC_DIR/Brewfile"

# ---------------------------------------------------------------------------
# 3. Mac symlinks
# ---------------------------------------------------------------------------
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

log "Creating symlinks..."
link_file "$MAC_DIR/zsh/zshrc" "$HOME/.zshrc"
link_file "$MAC_DIR/zsh/zprofile" "$HOME/.zprofile"
link_file "$MAC_DIR/zsh/config" "$HOME/.config/zsh"
link_file "$MAC_DIR/p10k/p10k.zsh" "$HOME/.p10k.zsh"
link_file "$MAC_DIR/ghostty/config.ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
link_file "$MAC_DIR/ssh/config" "$HOME/.ssh/config"
link_file "$MAC_DIR/ssh/config.local" "$HOME/.ssh/config.local"

# ---------------------------------------------------------------------------
# 4. Zsh plugins
# ---------------------------------------------------------------------------
PLUGINS_DIR="$MAC_DIR/zsh/config/plugins"
mkdir -p "$PLUGINS_DIR"

clone_plugin() {
  local url="$1"
  local name
  name="$(basename "$url")"
  if [[ -d "$PLUGINS_DIR/$name" ]]; then
    log "Plugin already present: $name"
  else
    log "Cloning plugin: $name"
    git clone --depth=1 "$url" "$PLUGINS_DIR/$name"
  fi
}

log "Syncing zsh plugins..."
clone_plugin "https://github.com/romkatv/powerlevel10k"
clone_plugin "https://github.com/zsh-users/zsh-autosuggestions"
clone_plugin "https://github.com/zsh-users/zsh-syntax-highlighting"

# ---------------------------------------------------------------------------
# 5. Shared config: git, mise tools, shell aliases, coding agents
# ---------------------------------------------------------------------------
"$DOTFILES_DIR/shared/install.sh" mac

# ---------------------------------------------------------------------------
# 6. Manual steps
# ---------------------------------------------------------------------------
cat <<'EOF'

==> Bootstrap complete. Pending manual steps:

  1. Sign in to 1Password, then in Settings > Developer enable:
     "Integrate with 1Password CLI" and "Use the SSH agent".
     (The SSH key and git signing config expect the agent to be on.)
  2. Authenticate the GitHub CLI:  gh auth login
  3. Create shared/git/allowed_signers in this repo (gitignored; linked
     as ~/.config/git/allowed_signers). One line per machine: the
     user.email address, then that machine's signing public key
     (mac/git/machine, omarchy/git/machine). Example:
       you@example.com ssh-ed25519 AAAA...
  4. Optional: create mac/ssh/config.local in this repo (gitignored;
     linked as ~/.ssh/config.local) with the Host blocks for private
     machines. mac/ssh/config already includes it.
  5. Open each installed app at least once to grant system
     permissions (accessibility, notifications, etc.).

EOF
