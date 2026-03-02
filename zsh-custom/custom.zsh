# Remove the last login message
touch ~/.hushlogin

# Custom default folder
cd $HOME/Documents/Code

#Theme
ZSH_THEME="robbyrussell"

#Custom git aliases
alias restartzsh="source ~/.zshrc"
alias restartohmyzsh="source ~/.oh-my-zsh"
alias code="cursor ."
alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'
alias gs="git status"
alias gc="git clone"
alias ga="git add -A"
alias gr="git rebase"
alias gb="git branch"
alias gbd="git branch -d" #delete specifying branch, ex. gbd otherBranch
alias gco="git checkout" #switch in this branch, ex. gco develop
alias gcob="git checkout -b" #Create the branch on your local machine and switch in this branch
alias gpsh="git push origin" #push to origin specifying branch, ex. gpsh master
alias gpll="git pull origin" #pull from origin specifying branch, ex. gpll master
alias gcm="git commit -m" #commit files with message
alias startpg="brew services start postgresql" #start postgres
alias stoppg="brew services stop postgresql" #stop postgres
alias startMongo="brew services start mongodb-community" #start mongo
alias stopMongo="brew services stop mongodb-community" #stop mongo
