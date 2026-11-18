CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$CACHE_DIR"

# Grok CLI, which T3 Code runs as its Grok provider.
[[ -d "$HOME/.grok/completions/zsh" ]] && fpath=("$HOME/.grok/completions/zsh" $fpath)

autoload -Uz compinit
compinit -d "$CACHE_DIR/zcompdump"