#!/usr/bin/env bash
# linuxing's Bash Pre Boostrapping Script (LBBUS)
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

###############################
## Basic colorscheme
###############################

RCol='\e[0m'   
Bla='\e[0;30m';     BBla='\e[1;30m';    UBla='\e[4;30m';    IBla='\e[0;90m';    BIBla='\e[1;90m';   On_Bla='\e[40m';    On_IBla='\e[0;100m';
Red='\e[0;31m';     BRed='\e[1;31m';    URed='\e[4;31m';    IRed='\e[0;91m';    BIRed='\e[1;91m';   On_Red='\e[41m';    On_IRed='\e[0;101m';
Gre='\e[0;32m';     BGre='\e[1;32m';    UGre='\e[4;32m';    IGre='\e[0;92m';    BIGre='\e[1;92m';   On_Gre='\e[42m';    On_IGre='\e[0;102m';
Yel='\e[0;33m';     BYel='\e[1;33m';    UYel='\e[4;33m';    IYel='\e[0;93m';    BIYel='\e[1;93m';   On_Yel='\e[43m';    On_IYel='\e[0;103m';
Blu='\e[0;34m';     BBlu='\e[1;34m';    UBlu='\e[4;34m';    IBlu='\e[0;94m';    BIBlu='\e[1;94m';   On_Blu='\e[44m';    On_IBlu='\e[0;104m';
Pur='\e[0;35m';     BPur='\e[1;35m';    UPur='\e[4;35m';    IPur='\e[0;95m';    BIPur='\e[1;95m';   On_Pur='\e[45m';    On_IPur='\e[0;105m';
Cya='\e[0;36m';     BCya='\e[1;36m';    UCya='\e[4;36m';    ICya='\e[0;96m';    BICya='\e[1;96m';   On_Cya='\e[46m';    On_ICya='\e[0;106m';
Whi='\e[0;37m';     BWhi='\e[1;37m';    UWhi='\e[4;37m';    IWhi='\e[0;97m';    BIWhi='\e[1;97m';   On_Whi='\e[47m';    On_IWhi='\e[0;107m';

blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

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

###############################
## Basic packages tools
###############################
#copy from 秋水逸冰 ss scripts
if [[ -f /etc/redhat-release ]]; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
    systemPackage="apt-get"
    systempwd="/lib/systemd/system/"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    systemPackage="yum"
    systempwd="/usr/lib/systemd/system/"
fi

if type xbps-install >/dev/null 2>&1; then
	installpkg(){ xbps-install -y "$1" >/dev/null 2>&1 ;}
	grepseq="\"^[PGV]*,\""
elif type apt >/dev/null 2>&1; then
	distro="debian"
	installpkg(){ sudo apt-get install -y "$1" >/dev/null 2>&1 ;}
	grepseq="\"^[PGA]*,\""
elif type apk >/dev/null 2>&1; then
	distro="alpine"
	installpkg(){ sudo apk add -y "$1" >/dev/null 2>&1 ;}
	grepseq="\"^[PGA]*,\""
else
	distro="arch"
	installpkg(){ sudo pacman --noconfirm --needed -S "$1" >/dev/null 2>&1 ;}
	grepseq="\"^[PGA]*,\""
fi

check_commands() {
  for command in $@
  do
  if ! command -v "${command}" > /dev/null 2>&1; then
    msg "You must have ${command}' installed to continue"
    installpkg "${command}"
  fi
  done
}

###############################
## Some aliases which make life easier 
###############################
alias reload="source ~/.bashrc"
alias db="cd ~/Dropbox"
alias ws="cd ~/workspace"
alias bashconfig="emacsclient -c ~/.bashrc"
alias ohmybash="emacsclient -c ~/.oh-my-bash"

###############################
## FS tools
###############################

#  dir and cd into it   
mcd() {  
    mkdir -pv "$@"  
    cd "$@"  
} 

# Create a new directory and enter it
mkd() {
	mkdir -p "$@" && cd "$@";
}

touchexe() {
	touch "$@" && chmod +x "$@";
}

# Change working directory to the top-most Finder window location
cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

ck() {  
  while true; do  
    clear;  
    echo "";  
    echo "    $(date +%r)";  
    echo "";  
    sleep 1;  
  done  
}  

fix() {  
  if [ -d $1 ]; then  
    find $1 -type d -exec chmod 755 {} \;  
    find $1 -type f -exec chmod 644 {} \;  
  else  
    echo "$1 is not a directory."  
  fi  
}  

###############################
## zip tools
###############################
# Create a .tar
mktar(){ tar cvf  "${1%%/}.tar"     "${1%%/}/"; }  

# Create a .tar.gz
mktgz(){ tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }  

# Create a .tar.bz2
mktbz(){ tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
mktgz2() {
	local tmpFile="${@%/}.tar";
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

	size=$(
		stat -f"%z" "${tmpFile}" 2> /dev/null; # OS X `stat`
		stat -c"%s" "${tmpFile}" 2> /dev/null # GNU `stat`
	);

	local cmd="";
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# the .tar file is smaller than 50 MB and Zopfli is available; use it
		cmd="zopfli";
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz";
		else
			cmd="gzip";
		fi;
	fi;

	echo "Compressing .tar using \`${cmd}\`…";
	"${cmd}" -v "${tmpFile}" || return 1;
	[ -f "${tmpFile}" ] && rm "${tmpFile}";
	echo "${tmpFile}.gz created successfully.";
}

# Determine size of a file or total size of a directory
fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* *;
	fi;
}

###############################
## Basic user home directory tools
###############################

init-org-home-directory() {

  today=$(date +%Y-%m-%d-%s)
  cd
  tar cvf "org.$today.tar" org
  rm -rf ~/org
  mkdir -p org
  cd org
  for dir in attach journal roam brain
  do
    rm -f $dir
    mkdir -p $dir
  done

  for file in inbox links snippets tutorials projects
  do
    rm -f "$file.org"
    touch "$file.org"
    echo "* $file org file created $today\n" >> "$file.org" 
  done
  echo "Done! Created org home directory!"
}

