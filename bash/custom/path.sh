#!/usr/bin/env bash

get_subbin() {
    joined_path=$(du "$1" | cut -f2 | tr '\n' ':' | sed 's/:*$//')
    echo joined_path
}

file_paths=(
"$HOME/EnvSetup/bash/bin"
"$HOME/bin"
"$HOME/.local/bin"
"$HOME/Dropbox/bin"
"$HOME/.nvm/bin"
"$HOME/.pyenv/bin"
)

for dir in file_paths; do
  if [[ -d $dir ]] && [[ ! "$PATH" == "*$dir*" ]]; then
    export PATH="$PATH:$(get_subbin $dir )"
  fi
done

# set pyenv virtual init environment
if [ -x "$HOME/.pyenv/bin/pyenv" ]; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$($HOME/.pyenv/bin/pyenv init -)"
  eval "$($HOME/.pyenv/bin/pyenv virtualenv-init -)"
fi

# set go environment
if command -v "go" >/dev/null 2>&1; then
  if [ ! -d "$HOME/workspace/go-project" ]; then
    mkdir -p "$HOME/workspace/go-project"
  fi
  export GO111MODULE="on"
  export GOROOT=/usr/lib/go
  export GOPATH=$HOME/workspace/go-project
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
fi
