#iTerm theme
ZSH_THEME="gitster"

#Custom git aliases
alias restartzsh="source ~/.zshrc"
alias ohmyzsh="source ~/.oh-my-zsh"
alias subl="subl ."
alias code="code ."
alias vs="code ."
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
alias hpsh="git push heroku" #push to heroku specifying branch, ex. gpsh master
alias hpll="git pull heroku" #pull from heroku specifying branch, ex. gpll master
alias gcm="git commit -m" #commit files with message
alias rs="rails server" #run rails server
alias startpg="brew services start postgresql" #start postgres
alias stoppg="brew services stop postgresql" #stop postgres
alias startphp="php -S 127.0.0.1:8080" #Start Php local server
