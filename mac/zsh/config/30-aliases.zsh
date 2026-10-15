# Mac-only aliases. Shared ones live in shared/shell/aliases.sh.
[[ -f ~/.config/shell/aliases.sh ]] && source ~/.config/shell/aliases.sh

alias restartzsh='source ~/.zshrc'
alias reloadzsh='exec zsh'

alias brewup='brew update && brew upgrade && brew cleanup && brew doctor'

alias startpg='brew services start postgresql'
alias stoppg='brew services stop postgresql'
alias startMongo='brew services start mongodb-community'
alias stopMongo='brew services stop mongodb-community'
