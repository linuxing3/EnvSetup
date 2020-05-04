#!/usr/bin/env bash

zz() {
  [ -f ~/.fzf.bash ] && source ~/.fzf.bash
}

export FZ_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build} --type f"

# export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --preview '(bat --theme zenburn {} | cat {} ) 2> /dev/null | head -500'"
export FZF_DEFAULT_OPTS="--height 40% --layout reverse --border\
  --preview '(bat --style=numbers --theme zenburn --color=always {} \
  || cat {} \
  || file {} ) \
  2> /dev/null \
  |  head -100' "

# Use ~~ as the trigger sequence instead of the default **
#export FZF_COMPLETION_TRIGGER='**'

# Options to fzf command
#export FZF_COMPLETION_OPTS='+c -x'

alias fiv='vim `fzf`'
alias fvf='vim `fzf`'
alias fv='vim `fzf`'
alias fn='nvim `fzf`'
alias fnv='nvim `fzf`'
alias fnf='nvim `fzf`'
alias fgit="git checkout \$(git branch -r | fzf)"
alias fdir="cd \$(find * -type d | fzf)"
