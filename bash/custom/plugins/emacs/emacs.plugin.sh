#!/usr/bin/env bash

alias es="emacs --daemon"
alias ec="emacsclient -c"
alias eq="emacs -q"
export DATA_DRIVE=$HOME
export CLOUD_SERVICE_PROVIDER=OneDrive
doomx() {
    export PATH=$PATH:~/.emacs.d/bin
    doom
}

eb() {
    emacs -q --batch -l ~/.emacs.editor --eval="$1"
}
