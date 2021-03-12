#!/usr/bin/env bash
#install go packages
# check arch, if i686, download 32 bit

OS=linux
MYARCH=$(arch)
if [ $MYARCH == "i686" ]; then
	ARCH="386"
	SHFMT_ARCH="386"
  GOGS_ARCH="386"
  GOGS_OS="linux"
elif [ $MYARCH == "x86_64" ]; then
	ARCH="amd64"
	SHFMT_ARCH="amd64"
  GOGS_ARCH="amd64"
  GOGS_OS="linux"
elif [ $MYARCH == "armv7l" ]; then
	ARCH="armv6l"
  SHFMT_ARCH="arm"
  GOGS_ARCH="armv6"
  GOGS_OS="raspi"
else
	ARCH="amd64"
	SHFMT_ARCH="amd64"
  GOGS_ARCH="amd64"
  GOGS_OS="linux"
fi

GO_VERSION=1.16
GOGS_VERSION=0.11.91
SHFMT_VERSION=3.1.1

install_shfmt() {
	wget -O shfmt "https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_${OS}_${SHFMT_ARCH}"
	sudo mv shfmt /usr/local/bin/
	type shfmt
}

install_gofish() {
	curl -fsSL https://raw.githubusercontent.com/fishworks/gofish/master/scripts/install.sh | bash
}

install_gvm() {
	curl -fsSL https://raw.github.com/moovweb/gvm/master/binscripts/gvm-installer | bash
	echo "gvm install go 1.16"
}

install_go_from_apt() {
	sudo add-apt-repository ppa:gophers/go
	sudo apt-get update
	sudo apt-get install golang-stable
}

install_go() {
	echo "$HOME/gopath is the default workspace directory."
	echo "/usr/lib/go is the directory where Go will be installed to."
	wget https://dl.google.com/go/go$GO_VERSION.$OS-$ARCH.tar.gz
	sudo tar -C /usr/local -xzf go$GO_VERSION.$OS-$ARCH.tar.gz
	type go
	setup_go_env
}

install_go_one_key() {
	echo "$HOME/.go is the directory where Go will be installed to."
	echo "$HOME/go is the default workspace directory."
	wget -q -O - https://git.io/vQhTU | bash
	type go
}

remove_go_one_key() {
	wget -q -O - https://git.io/vQhTU | bash -s -- --remove
	type go
}

install_gogs() {
	cd 
	wget https://github.com/gogs/gogs/releases/download/v$GOGS_VERSION/$GOGS_OS-$GOGS_ARCH.zip
	sudo zip $OS-$ARCH.zip
	echo "Installed gogs, to start run"
	echo "cd gogs && ./gogs web"
}

setup_go_env() {
	if [ ! -d "$HOME/gopath/src/github.com" ]; then
		mkdir -p "$HOME/gopath/src/github.com"
	fi
	export GO111MODULE="on"
	export GOROOT=/usr/local/go
	export GOPATH=$HOME/gopath
	export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
	echo "You can also enalbe go environment with ggg!!!"
}

setup_go_emacs() {
	echo "Installing tools for doom emacs and vscode"
  go get -u github.com/motemen/gore/cmd/gore
  go get -u github.com/stamblerre/gocode
	go get -u golang.org/x/tools/...
	go get github.com/spf13/cobra/cobra
	go get golang.org/x/tools/cmd/gopls
	go get github.com/go-delve/delve/cmd/dlv
  go get golang.org/x/tools/cmd/goimports
  go get golang.org/x/tools/cmd/gorename
  go get golang.org/x/tools/cmd/guru
}

option=$(dialog --title " Go一键安装自动脚本" \
	--checklist "请输入:" 20 70 5 \
	"1" "Install shfmt" 0 \
	"2" "Install gofish package manager" 0 \
	"3" "Install go from official site" 0 \
	"4" "Install go from one key" 0 \
	"5" "Install go tools" 0 \
	"6" "Install gogs" 0 \
	"7" "Setup go environment" 0 \
	3>&1 1>&2 2>&3 3>&1)
case "$option" in
1)
	install_shfmt
	;;
2)
	install_gofish
	;;
3)
	install_go
	;;
4)
	install_go_one_key
	;;
5)
	setup_go_emacs
	;;
6)
	setup_gogs
	;;
7)
	setup_go_env
	;;
*)
	echo "Skipped!"
	;;
esac
