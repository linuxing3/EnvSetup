#!/usr/bin/env bash
# linuxing's Bash Path Script 
# by linuxing3 <linuxing3@qq.com>
# License: GNU GPLv3
#
#                                        _
#    ___ _ __   __ _  ___ ___     __   _(_) 
#   / __| -_ \ / _- |/ __/ _ \____\ \ / 
#   \__ \ |_) | (_| | (_|  __/_____\ V /
#   |___/ .__/ \__._|\___\___|      \_/ 
#       |_|
#
#

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

# PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PATH
for dir in "${file_paths[@]}"; do
  if [[ -d $dir ]] && [[ ! "$PATH" == "*$dir*" ]]; then
    subdirs=$(get_subbin $dir)
    # echo "Adding the following $subdirs to path"
    export PATH="$subdirs:$PATH"
  fi
done

