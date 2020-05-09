#!/usr/bin/env bash

# set pyenv virtual init environment
vvv() {
	if command -v "pyenv" >/dev/null 2>&1; then
		eval "$(pyenv init -)"
		eval "$(pyenv virtualenv-init -)"
	fi
}

vvv

alias pv="pyenv"
alias pvv="pyenv virtualenvs"
alias pva="pyenv activate"
alias pvg="pyenv global"
alias pvs="pyenv shell"

alias ppvs="pipenv shell"
alias ppvl="pipenv lock"
alias ppvi="pipenv install"

alias nb="jupyter-notebook"
alias ipy="ipython"
alias vno="virtualenv test --no-download --no-pip --no-setup-tools"

