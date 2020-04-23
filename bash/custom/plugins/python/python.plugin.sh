#!/usr/bin/env bash

# set pyenv virtual init environment
if command -v "pyenv" >/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

alias pv="pyenv"
