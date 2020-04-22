#!/bin/sh

cmd=$(which tmux)
session=codefun

if [ -z $cmd ]; then
    echo "You need to install tmux first"
    exit 1
fi

$cmd has -t $session 2> /dev/null

if [ $? -ne 0 ]; then
    $cmd new -d -n dashboard -s $session "bash"
    $cmd neww -n emacs -t $session "emacs"
    $cmd neww -n web -t $session "elinks"
    $cmd neww -n bash -t $session "cowsay -T -W Welcome"
    $cmd splitw -v -p 20 -t $session "bash"
    $cmd neww -n bash -t $session "cowsay -T -W Welcome"
    $cmd splitw -h -p 50 -t $session "bash"
    $cmd neww -n system -t $session "top"
fi

$cmd att -t $session
exit 0

