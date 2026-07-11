CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$CACHE_DIR"

autoload -Uz compinit
compinit -d "$CACHE_DIR/zcompdump"