# Aliases and functions shared by both machines (zsh on the Mac, bash on the
# PC). Linked as ~/.config/shell/aliases.sh. Keep it portable to both shells.

# Git
alias gs='git status'
alias gc='git clone'
alias ga='git add -A'
alias gr='git rebase'
alias gb='git branch'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gpsh='git push origin'
alias gpll='git pull origin'
alias gcm='git commit -m'

# Open the current folder (or the given paths) in Cursor.
code() {
  if [ "$#" -eq 0 ]; then
    cursor .
  else
    cursor "$@"
  fi
}

# Code folder: ~/Documents/Code on the Mac, ~/Code on the PC.
if [ -d "$HOME/Documents/Code" ]; then
  export DEV_DIR="$HOME/Documents/Code"
else
  export DEV_DIR="$HOME/Code"
fi

# New interactive shells that start in $HOME open in the code folder.
case $- in
  *i*) [ -d "$DEV_DIR" ] && [ "$PWD" = "$HOME" ] && builtin cd "$DEV_DIR" ;;
esac
