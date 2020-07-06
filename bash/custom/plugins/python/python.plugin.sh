#!/usr/bin/env bash

# set  anaconda
init-conda() {
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('/home/linuxing3/.anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "/home/linuxing3/.anaconda3/etc/profile.d/conda.sh" ]; then
          . "/home/linuxing3/.anaconda3/etc/profile.d/conda.sh"
      else
          export PATH="/home/linuxing3/.anaconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<
}

dada() {
  export PATH=$HOME/.anaconda3/bin:$PATH
}

# set pyenv virtual init environment
vvv() {
	if command -v "pyenv" >/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
  else
    export PATH=$HOME/.pyenv/bin:$PATH
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

alias vno="virtualenv"

alias vwa="workon test"
alias vwmk="mkvirtualenv"
alias vwcd="cdvirtualenv"
alias vwrm="rmvirtualenv"

alias danv="conda env create"
alias daav="conda activate"
