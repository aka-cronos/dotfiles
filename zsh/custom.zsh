# Example aliases
alias zshconfig="source ~/.zshrc"
alias ohmyzsh="source ~/.oh-my-zsh"
alias subl="subl ."

alias ls='colorls -r -1'
alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'
#Custom git aliases
alias gs="git status"
alias gc="git clone"
alias ga="git add -A"
alias gr="git rebase"
alias gb="git branch"
alias gbd="git branch -d" #delete specifying branch, ex. gbd otherBranch
alias gco="git checkout"
alias gcob="git checkout -b" #Create the branch on your local machine and switch in this branch
alias gpsh="git push origin" #push to origin specifying branch, ex. gpsh master
alias gpll="git pull origin" #pull from origin specifying branch, ex. gpll master
alias hpsh="git push heroku" #push to origin specifying branch in heroku, ex. gpsh master
alias hpll="git pull heroku" #pull from origin specifying branch in heroku, ex. gpll master
alias gcm="git commit -m" #commit files
alias rs="rails server" #run rails server

#see tree directory levels
function t() {
  tree -I '.git|node_modules|bower_components|.DS_Store' --dirsfirst --filelimit 20 -L ${1:-3} -aC $2
}