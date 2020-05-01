#!/usr/bin/env bash

get_subbin() {
    joined_path=$(du "$1" | cut -f2 | tr '\n' ':' | sed 's/:*$//')
    echo $joined_path
}

file_paths=(
"$HOME/EnvSetup/bash/bin"
"$HOME/Dropbox/bin"
"$HOME/bin"
"$HOME/.local/bin"
"$HOME/.nvm/bin"
"$HOME/.pyenv/bin"
)

for dir in "${file_paths[@]}"; do
  if [[ -d $dir ]] && [[ ! "$PATH" == "*$dir*" ]]; then
    subdirs=$(get_subbin $dir)
    # echo "Adding the following $subdirs to path"
    export PATH="$PATH:$subdirs"
  fi
done

