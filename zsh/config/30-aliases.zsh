alias restartzsh='source ~/.zshrc'
alias reloadzsh='exec zsh'

alias brewup='brew update && brew upgrade && brew cleanup && brew doctor'

alias gs='git status'
alias gc='git clone'
alias ga='git add -A'
alias gr='git rebase'
alias gb='git branch'
alias gbd='git branch -d'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gpsh='git push origin'
alias gpll='git pull origin'
alias gcm='git commit -m'
alias gbD='git branch -D' # force delete (recovered from oh-my-zsh git plugin)

alias startpg='brew services start postgresql'
alias stoppg='brew services stop postgresql'
alias startMongo='brew services start mongodb-community'
alias stopMongo='brew services stop mongodb-community'