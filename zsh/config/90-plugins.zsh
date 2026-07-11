# -----------------------------------------------------------------------------
# zsh-autosuggestions
# -----------------------------------------------------------------------------
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5C6974'
ZSH_AUTOSUGGEST_USE_ASYNC=true

if [[ -f ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# -----------------------------------------------------------------------------
# zsh-syntax-highlighting
# -----------------------------------------------------------------------------
typeset -gA ZSH_HIGHLIGHT_STYLES

ZSH_HIGHLIGHT_STYLES[default]='fg=#E6E6E6'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF5C5C,bold'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#46474F,italic'
ZSH_HIGHLIGHT_STYLES[command]='fg=#E6E7A3'
ZSH_HIGHLIGHT_STYLES[function]='fg=#E6E7A3'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#E6E7A3'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#868F97'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#E6E7A3'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#9099A1'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#54C0A3'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#54C0A3'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#54C0A3'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#9099A1'
ZSH_HIGHLIGHT_STYLES[path]='fg=#E6E6E6'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#868F97'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#5C6974'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#F9B98C'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#F9B98C'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#F9B98C'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#479FFA'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#479FFA'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#54C0A3'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#54C0A3'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#479FFA,bold'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=#E6E6E6'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#5C6974'
ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=#868F97'
ZSH_HIGHLIGHT_STYLES[math-expansion]='fg=#F9B98C'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#F9B98C'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#9099A1'
ZSH_HIGHLIGHT_STYLES[redirection-number]='fg=#F9B98C'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#5C6974'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#E6E6E6'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#F9B98C'

if [[ -f ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi