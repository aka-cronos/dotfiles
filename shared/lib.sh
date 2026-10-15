# Helpers sourced by the setup scripts. Portable to macOS's bash 3.2.

# One backup folder per run, shared with any script this run calls.
: "${DOTFILES_BACKUP_DIR:=$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)-$$}"
export DOTFILES_BACKUP_DIR

log() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }

# Move a real file out of the way, keeping its path under $HOME so two files
# with the same name (e.g. two AGENTS.md) don't overwrite each other.
backup_path() {
  local path="$1"
  local rel="${path#"$HOME"/}"
  local dest="$DOTFILES_BACKUP_DIR/$rel"
  log "Backing up $path -> $dest"
  mkdir -p "$(dirname "$dest")"
  mv "$path" "$dest"
}

link_file() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    backup_path "$dst"
  fi

  ln -sfn "$src" "$dst"
  log "Symlink: $dst -> $src"
}

# Copy a file (for things that can't be symlinks), backing up a different one.
copy_file() {
  local src="$1"
  local dst="$2"
  local mode="$3"

  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" ]] && ! cmp -s "$src" "$dst"; then
    backup_path "$dst"
  fi

  install -m "$mode" "$src" "$dst"
  log "Copy: $dst <- $src"
}
