#!/usr/bin/env bash
# linuxing's Bash Boostrapping Script (LARBS)
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

set -eo pipefail

[ -z "$app_name" ] && app_name="EnvSetup"
[ -z "$repo_uri" ] && repo_uri="https://github.com/linuxing3/EnvSetup.git"
[ -z "$repo_name" ] && repo_name="EnvSetup"
[ -z "$repo_path" ] && repo_path="$HOME/EnvSetup"
[ -z "$repo_branch" ] && repo_branch="master"
[ -z "$progsfile" ] && progsfile="https://raw.githubusercontent.com/linuxing3/EnvSetup/master/progs.csv"
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
    --install)       _install=1    ;;
    --remove)        _remove=1 ;;
    *)
      echo "unknown option: $opt"
      help
      exit 1
      ;;
  esac
done

###############################
## Basic tools
###############################
msg() {
  printf '%b\n' "$1" >&2
}

success() {
  if [ "$ret" -eq '0' ]; then
    msg "\\33[32m[✔]\\33[0m ${1}${2}"
  fi
}

error() {
  msg "\\33[31m[✘]\\33[0m ${1}${2}"
  exit 1
}

exists() {
  command -v "$1" >/dev/null 2>&1
}

if type xbps-install >/dev/null 2>&1; then
	installpkg(){ xbps-install -y "$1" >/dev/null 2>&1 ;}
	grepseq="\"^[PGV]*,\""
elif type apt >/dev/null 2>&1; then
	installpkg(){ apt-get install -y "$1" >/dev/null 2>&1 ;}
	grepseq="\"^[PGU]*,\""
elif type apk >/dev/null 2>&1; then
	installpkg(){ apk add -y "$1" >/dev/null 2>&1 ;}
	grepseq="\"^[PGU]*,\""
else
	distro="arch"
	installpkg(){ pacman --noconfirm --needed -S "$1" >/dev/null 2>&1 ;}
	grepseq="\"^[PGA]*,\""
fi

###############################
## Commands
###############################
welcomemsg() { \
	dialog --title "Welcome!" --msgbox "Welcome to Linuxing3's Bootstrapping Script!\\n\\nThis script will automatically install a fully-featured Linux desktop"
	}

getuserandpass() { \
	# Prompts user for new username an password.
	name=$(dialog --inputbox "First, please enter a name for the user account." 10 60 3>&1 1>&2 2>&3 3>&1) || exit
	while ! echo "$name" | grep "^[a-z_][a-z0-9_-]*$" >/dev/null 2>&1; do
		name=$(dialog --no-cancel --inputbox "Username not valid. Give a username beginning with a letter, with only lowercase letters, - or _." 10 60 3>&1 1>&2 2>&3 3>&1)
	done
	pass1=$(dialog --no-cancel --passwordbox "Enter a password for that user." 10 60 3>&1 1>&2 2>&3 3>&1)
	pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	while ! [ "$pass1" = "$pass2" ]; do
		unset pass2
		pass1=$(dialog --no-cancel --passwordbox "Passwords do not match.\\n\\nEnter password again." 10 60 3>&1 1>&2 2>&3 3>&1)
		pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	done ;}

usercheck() { \
	! (id -u "$name" >/dev/null) 2>&1 ||
	dialog --colors --title "WARNING!" --yes-label "CONTINUE" --no-label "No wait..." --yesno "The user \`$name\` already exists on this system. LARBS can install for a user already existing, but it will \\Zboverwrite\\Zn any conflicting settings/dotfiles on the user account.\\n\\nLARBS will \\Zbnot\\Zn overwrite your user files, documents, videos, etc., so don't worry about that, but only click <CONTINUE> if you don't mind your settings being overwritten.\\n\\nNote also that LARBS will change $name's password to the one you just gave." 14 70
	}

preinstallmsg() { \
	dialog --title "Let's get this party started!" --yes-label "Let's go!" --no-label "No, nevermind!" --yesno "The rest of the installation will now be totally automated, so you can sit back and relax.\\n\\nIt will take some time, but when done, you can relax even more with your complete system.\\n\\nNow just press <Let's go!> and the system will begin installation!" 13 60 || { clear; exit; }
	}

adduserandpass() { \
	# Adds user `$name` with password $pass1.
	dialog --infobox "Adding user \"$name\"..." 4 50
	useradd -m -g wheel -s /bin/bash "$name" >/dev/null 2>&1 ||
	usermod -a -G wheel "$name" && mkdir -p /home/"$name" && chown "$name":wheel /home/"$name"
	repodir="/home/$name/.local/src"; mkdir -p "$repodir"; chown -R "$name":wheel "$repodir"
	echo "$name:$pass1" | chpasswd
	unset pass1 pass2 ;}

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

check_commands() {
  if ! exists "git"; then
    error "You must have 'git' installed to continue"
    installpkg git
  fi
  if ! exists "curl"; then
    error "You must have 'curl' installed to continue"
    installpkg curl
  fi
  if ! exists "dialog"; then
    error "You must have 'dialog' installed to continue"
    installpkg dialog
  fi
  echo "All checked!"
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
      ;;
    1)
      echo "Not bootstrap"
      ;;
    *)
      echo "Please answer 0, 1 or 2"
      ;;
    esac
}

install() {
  if [ ! -z "$_remove" ]; then
    remove
    return
  fi
  if [ ! -z "$_install" ]; then
    sync_repo
    bootstrap
    msg "\\nThanks for using \\033[1;31m$app_name\\033[0m. Enjoy!"
    return
  else
    help
  fi
}

manualinstall() { # Installs $1 manually if not installed. 
	[ -f "/usr/bin/$1" ] || (
	dialog --infobox "Installing \"$1\", an AUR helper..." 4 50
	cd /tmp || exit
	rm -rf /tmp/"$1"*
	curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz &&
	sudo -u "$name" tar -xvf "$1".tar.gz >/dev/null 2>&1 &&
	cd "$1" &&
	sudo -u "$name" makepkg --noconfirm -si >/dev/null 2>&1
	cd /tmp || return) ;}

maininstall() { # Installs all needed programs from main repo.
	dialog --title "LARBS Installation" --infobox "Installing \`$1\` ($n of $total). $1 $2" 5 70
	installpkg "$1"
	}

pipinstall() { \
	dialog --title "LARBS Installation" --infobox "Installing the Python package \`$1\` ($n of $total). $1 $2" 5 70
	command -v pip || installpkg python-pip >/dev/null 2>&1
	yes | pip install "$1"
	}

installationloop() { \
	([ -f "$progsfile" ] && cp "$progsfile" /tmp/progs.csv) || curl -Ls "$progsfile" | sed '/^#/d' | eval grep "$grepseq" > /tmp/progs.csv
	total=$(wc -l < /tmp/progs.csv)
	aurinstalled=$(pacman -Qqm)
	while IFS=, read -r tag program comment; do
		n=$((n+1))
		echo "$comment" | grep "^\".*\"$" >/dev/null 2>&1 && comment="$(echo "$comment" | sed "s/\(^\"\|\"$\)//g")"
		case "$tag" in
			"A") aurinstall "$program" "$comment" ;;
			"G") gitmakeinstall "$program" "$comment" ;;
			"P") pipinstall "$program" "$comment" ;;
			*) maininstall "$program" "$comment" ;;
		esac
	done < /tmp/progs.csv ;}

finalize(){ \
	dialog --infobox "Preparing welcome message..." 4 50
	echo "exec_always --no-startup-id notify-send -i ~/.local/share/larbs/larbs.png 'Welcome to LARBS:' 'Press Super+F1 for the manual.' -t 10000"  >> "/home/$name/.config/i3/config"
	dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\\n\\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment (it will start automatically in tty1).\\n\\n.t Luke" 12 80
	}
###############################
##  main
###############################
# Welcome user and pick dotfiles.
# welcomemsg || error "User exited."

# Get and verify username and password.
# getuserandpass || error "User exited."

# Give warning if user already exists.
# usercheck || error "User exited."

# Last chance for user to back out before install.
preinstallmsg || error "User exited."
#
#### The rest of the script requires no user input.
#
#adduserandpass || error "Error adding username and/or password."
dialog --title "Pre Installation" --infobox "Installing \`dialog\` and \`git\`." 5 70
check_commands
#
dialog --title "Installation" --infobox "Installing..." 5 70
installationloop
#
#finalize
