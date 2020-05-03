#!/usr/bin/env bash

# set pyenv virtual init environment
vv() {
  if command -v "pyenv" >/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  fi
}

alias pv="pyenv"
alias pvv="pyenv virtualenvs"
alias pva="pyenv activate"
alias pvg="pyenv global"
alias pvs="pyenv shell"

alias ppvs="pipenv shell"
alias ppvl="pipenv lock"
alias ppvi="pipenv install"
