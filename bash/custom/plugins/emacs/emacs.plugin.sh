#!/usr/bin/env bash

alias es="emacs --daemon"
alias ec="emacsclient -c"
alias eq="emacs -q"

doomx() {
    export PATH=$PATH:~/.emacs.d/bin
    doom
}

eb() {
    emacs -q --batch -l ~/.emacs.editor --eval="$1"
}
