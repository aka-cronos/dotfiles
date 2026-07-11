if [[ -f ~/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme ]]; then
  source ~/.config/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
fi

[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

typeset -g POWERLEVEL9K_DIR_CONTENT_EXPANSION='${${(%):-%1~}//\%/%%}'
(( $+functions[p10k] )) && p10k reload