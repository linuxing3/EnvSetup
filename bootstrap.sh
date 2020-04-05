#!/usr/bin/env bash

remote_repo=https://github.com/linuxing3/bestdotfiles.git
local_repo=$HOME/dotfiles

version() {
  echo "$(basename $0) 0.6.3 by linuxing3 <linuxing3@qq.com>"
  echo "https://github.com/linuxing3/bestdotfiles"
}

doIt() {
	cd "$(dirname "${BASH_SOURCE}")";
    #git clone https://gitcafe.com/linuxing3/dotvim ~/.vim
    #ln -s ~/.vim/.vimrc ~/.vimrc
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE-MIT.txt" --exclude ".w3m/" \
		--exclude ".calcurse" --exclude ".gitignore" \
                --exclude ".gitmodules" --exclude ".hgignore" --exclude ".ssh/" \
		--exclude "init/" --exclude "bin/" --exclude "docker/" --exclude "data/" --exclude "doc/" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
}

local(){
	if [ "$1" == "--force" -o "$1" == "-f" ]; then
		doIt;
	else
		read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
		echo "";
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			doIt;
		fi;
	fi;
	unset doIt;
}

usage() {
    version
cat << EOF >&2

easily bootstrap local dot files tools with Git

Usage:
    $(basename $0) [options]

Example:
    $(basename $0) redis

Options:
    -l, --local              Rsyncronize locally to your home folder
    -r, --remote             Deploy to your remote git repository
    -u, --upgrade            Upgrade from remote git repository 
    -d, --remove             Stop and remove all dot files in home folder
    -h, --help               Display this help text
    -v, --version            Display current script version
EOF
}

# cloning from remote repositry
clone() {
  if [ $1 -a $1 = '--silently' ]; then
    git clone -q "$remote_repo" "$local_repo"
  else
    echo "Cloning $remote_repo to $local_repo"
    git clone "$remote_repo" "$local_repo"
  fi
}


upgrade() {
  if [ ! -e "$local_repo/.git" ]; then
    clone
  else
    cd "$local_repo"
    git pull origin master
  fi
}


init() {
  if [ ! -e "$local_repo/.git" ]; then
    clone $1
  fi
}

remote() {
	echo Deploying your dotfiles to remote reposity
	#deploy "continious update"
	#doing the following steps
	 git add .
	 git commit -m "continious updating"
	 git push -u origin master
}

remove() {
  echo "Removing all dotfiles in your home directory"
  cd ~/
}
# --- Main entry point ----------------------
if [ $# -eq 0 ]; then
  usage
  exit 0
fi

## Parse comand-line options
while [ $# -gt 0 ]; do
  case $1 in
    -v | --version )
      version
      exit 1
      ;;
    -l | --local)
      local
      exit
      ;;
    -r | --remote )
      remote
      exit
      ;;
    -h | --help )
      usage
      exit 1
      ;;
    -u | --upgrade )
      upgrade
      exit
      ;;
    -d | --remove )
      remove
      exit
      ;;
    * ) # default case
      start $1
      ;;
  esac
  shift
done
