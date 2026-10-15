# Additions to Omarchy's ~/.bashrc. omarchy/install.sh adds a line to
# ~/.bashrc that sources this file (linked as ~/.config/shell/bashrc.sh)
# after Omarchy's own aliases, so anything here wins.

[[ -f ~/.config/shell/aliases.sh ]] && source ~/.config/shell/aliases.sh

# Omarchy maps `c` to OpenCode, which is not installed here.
unalias c 2>/dev/null || true
