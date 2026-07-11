#!/usr/bin/env bash
# Bootstrap for a new Mac (or to re-sync an already configured one).
# Idempotent: safe to run as many times as needed.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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
# 2. Brewfile
# ---------------------------------------------------------------------------
log "Installing Brewfile packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# ---------------------------------------------------------------------------
# 3. Symlinks
# ---------------------------------------------------------------------------
link_file() {
  local src="$1"
  local dst="$2"
  local dst_parent
  dst_parent="$(dirname "$dst")"

  mkdir -p "$dst_parent"

  if [[ -e "$dst" || -L "$dst" ]] && [[ ! -L "$dst" ]]; then
    log "Backing up $dst -> $BACKUP_DIR/"
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/"
  fi

  ln -sfn "$src" "$dst"
  log "Symlink: $dst -> $src"
}

log "Creating symlinks..."
link_file "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/zsh/zprofile" "$HOME/.zprofile"
link_file "$DOTFILES_DIR/zsh/config" "$HOME/.config/zsh"
link_file "$DOTFILES_DIR/p10k/p10k.zsh" "$HOME/.p10k.zsh"
link_file "$DOTFILES_DIR/ghostty/config.ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty"
link_file "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/git/ignore" "$HOME/.config/git/ignore"

# ---------------------------------------------------------------------------
# 4. Zsh plugins
# ---------------------------------------------------------------------------
PLUGINS_DIR="$DOTFILES_DIR/zsh/config/plugins"
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
# 5. Manual steps
# ---------------------------------------------------------------------------
cat <<'EOF'

==> Bootstrap complete. Pending manual steps:

  1. Sign in to 1Password (app + enable the 'op' CLI).
  2. Authenticate the GitHub CLI:  gh auth login
  3. Open each installed app at least once to grant system
     permissions (accessibility, notifications, etc.).
  4. If you want your Claude Code / Cursor skills:
       npx skills add aka-cronos/skills -g

EOF
