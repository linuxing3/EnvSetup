#!/bin/sh
#
# name     : tile， tmux environment made easy
# author   : xing wenju 
# license  : GPL
# created  : 2014 Jul 01
#

cmd=$(which tmux) # tmux path
session=linuxing3   # session name

if [ -z $cmd ]; then
  echo "You need to install tmux."
  exit 1
fi

$cmd has -t $session

if [ $? != 0 ]; then
  $cmd new -d -n bash -t $session "bash"
  $cmd new -n -n ranger -t $session "ranger ~/EnvSetup"
  $cmd new -d -n vim -s $session "vim ~/EnvSetup"
  $cmd neww -n bash-horizonal -t $session "bash"
  $cmd splitw -p 30 -t $session "bash"
  $cmd neww -n bash-vertical -t $session "bash"
  $cmd splitw -h -p 50 -t $session "bash"
  $cmd neww -n lede -t $session "ssh -X root@192.168.1.2"
  $cmd neww -n xunqinji -t $session "ssh -X root@xunqinji.top"
  $cmd neww -n dongxishijie -t $session "ssh -X root@dongxishijie.xyz"
  $cmd neww -n monitor -t $session "top"
  $cmd selectw -t $session:1
fi

$cmd att -t $session

exit 0
