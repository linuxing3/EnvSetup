#!/usr/bin/env bash
#
#                                        _
#    ___ _ __   __ _  ___ ___     __   _(_) 
#   / __| -_ \ / _- |/ __/ _ \____\ \ / 
#   \__ \ |_) | (_| | (_|  __/_____\ V /
#   |___/ .__/ \__._|\___\___|      \_/ 
#       |_|
#

set -eo pipefail

app_name="EnvSetup"
repo_uri="https://github.com/linuxing3/EnvSetup.git"
repo_name="EnvSetup"
repo_path="$HOME/EnvSetup"
repo_branch="master"
_install=
_remove=

help() {
  cat << EOF
usage: $0 [OPTIONS]

    --help               Show this message
    --install            Install EnvSetup
    --remove             Remove EnvSetup
EOF
}

for opt in "$@"; do
  case $opt in
    --help)
      help
      exit 0
      ;;
    --install)       _all=1    ;;
    --remove)        _remove=1 ;;
    *)
      echo "unknown option: $opt"
      help
      exit 1
      ;;
  esac
done

###############################
## Commands
###############################
sync_repo() {
  if [ ! -e "$repo_path" ]; then
    msg "\\033[1;34m==>\\033[0m Trying to clone $repo_name"
    mkdir -p "$repo_path"
    git clone -b "$repo_branch" "$repo_uri" "$repo_path" --depth=1
    ret="$?"
    success "Successfully cloned $repo_name."
  else
    msg "\\033[1;34m==>\\033[0m Trying to update $repo_name"
    cd "$repo_path" && git pull origin "$repo_branch"
    ret="$?"
    success "Successfully updated $repo_name"
  fi
  if [ ! -z "$_update" ]; then
    exit 0;
  fi
}


backup() {
  if [ -e "$1" ]; then
    echo
    msg "\\033[1;34m==>\\033[0m Attempting to back up your original vim configuration"
    today=$(date +%Y%m%d_%s)
    mv -v "$1" "$1.$today"

    ret="$?"
    success "Your original configuration has been backed up"
  fi
}

check_git() {
  if ! exists "git"; then
    error "You must have 'git' installed to continue"
  fi
}


remove() {
  read -r -p "Backup: [0]yes [1]no?" opt
  case $opt in
    0)
      msg "\\033[1;34m==>\\033[0m Trying to backup EnvSetup"
      backup "$HOME/EnvSetup"
      break
      ;;
    1)
      echo "Not backuped"
      break
      ;;
    *)
      echo "Please answer 0, 1 or 2"
      ;;
    esac
  rm -rf "$HOME/EnvSetup"
  msg "\\nThanks for using \\033[1;31m$app_name\\033[0m. Chao!"
}

bootstrap() {
  read -r -p "Bootstrap now: [0]yes [1]no?" opt
  case $opt in
    0)
      echo "Bootstrap Now"
      if [ ! -e "$repo_path" ]; then
        msg "\\033[1;34m==>\\033[0m EnvSetup not ready, install it again?"
      else
        bash ~/EnvSetup/bootstrap.sh
      fi
      break
      ;;
    1)
      echo "Not bootstrap"
      break
      ;;
    *)
      echo "Please answer 0, 1 or 2"
      ;;
    esac
}

install() {
  if [ ! -z "$_install" ]; then
    sync_repo
    bootstrap
    msg "\\nThanks for using \\033[1;31m$app_name\\033[0m. Enjoy!"
    return
  fi
  if [ ! -z "$_remove" ]; then
    remove
    return
  fi
}

###############################
##  main
###############################
check_git

install
