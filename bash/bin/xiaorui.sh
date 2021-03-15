#!/bin/sh

cmd=$(which tmux)
session=codefun

if [ -z $cmd ]; then
    echo "You need to install tmux first"
    exit 1
fi

$cmd has -t $session 2> /dev/null

if [ $? -ne 0 ]; then
    $cmd new -d -n dashboard -s $session "bashtop"
    $cmd neww -n bash -t $session "bash"
    $cmd neww -n bash -t $session "bash"
    $cmd neww -n vim -t $session "nvim"
    $cmd neww -n bash -t $session "ranger"
    $cmd neww -n system -t $session "docker ps"
fi

$cmd att -t $session
exit 0

