#!/bin/sh
#
# name     : tile， tmux environment made easy
# author   : xing wenju 
# license  : GPL
# created  : 2020 Apr 01
#

cmd=$(which tmux) # tmux path
session=workspace   # session name

if [ -z $cmd ]; then
  echo "You need to install tmux."
  exit 1
fi

$cmd has -t $session

if [ $? != 0 ]; then
  $cmd new -d -n dashboard -t $session "bash"
  $cmd neww -n web -t $session "elinks"
  $cmd neww -n ranger -t $session "ranger ~/EnvSetup"
  $cmd neww -n bash-vertical -t $session "bash"
  $cmd splitw -h -p 50 -t $session "bash"
  $cmd neww -n monitor -t $session "top"
  $cmd selectw -t $session:1
fi

$cmd att -t $session

exit 0
