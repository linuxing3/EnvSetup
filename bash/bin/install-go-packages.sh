#!/usr/bin/env bash
#install go packages
# check arch, if i686, download 32 bit

OS=linux
MYARCH=$(arch)
if [ $MYARCH == "i686" ]; then
	ARCH="386"
elif [ $MYARCH == "x86_64" ]; then
	ARCH="amd64"
elif [ $MYARCH == "armv7l" ]; then
	ARCH="armv7"
	OS="raspi"
else
	ARCH="amd64"
fi

GO_VERSION=1.14.2
GOGS_VERSION=0.11.91
SHFMT_VERSION=3.1.1

install_shfmt() {
	wget -O shfmt "https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_${OS}_${ARCH}"
	sudo mv shfmt /usr/local/bin/
	type shfmt
}

install_gofish() {
	curl -fsSL https://raw.githubusercontent.com/fishworks/gofish/master/scripts/install.sh | bash
}

install_gvm() {
	bash < <(curl -s https://raw.github.com/moovweb/gvm/master/binscripts/gvm-installer)
	echo "gvm install go1.4.1"
}

install_go_from_apt() {
	sudo add-apt-repository ppa:gophers/go
	sudo apt-get update
	sudo apt-get install golang-stable
}

install_go() {
	wget https://dl.google.com/go/go$GO_VERSION.$OS-$ARCH.tar.gz
	sudo tar -C /usr/lib -xzf go$GO_VERSION.$OS-$ARCH.tar.gz
	type go
}

install_gogs() {
	cd 
	wget https://github.com/gogs/gogs/releases/download/v$GOGS_VERSION/$OS-$ARCH.zip
	sudo zip $OS-$ARCH.zip
	echo "Installed gogs, to start run"
	echo "cd gogs && ./gogs web"
}

setup_go_env() {
	if [ ! -d "$HOME/workspace/go-project" ]; then
			mkdir -p "$HOME/workspace/go-project"
		fi
		export GO111MODULE="on"
		export GOROOT=/usr/lib/go
		export GOPATH=$HOME/workspace/go-project
		export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
		echo "You can enalbe go environment with ggg!!!"
}

setup_go_emacs() {
	echo "Installing tools for doom emacs and vscode"
  go get -u github.com/motemen/gore/cmd/gore
  go get -u github.com/stamblerre/gocode
	go get -u golang.org/x/tools/...
  go get -u golang.org/x/tools/cmd/godoc
  go get -u golang.org/x/tools/cmd/goimports
  go get -u golang.org/x/tools/cmd/gorename
  go get -u golang.org/x/tools/cmd/guru
	go get -u golang.org/x/tools/cmd/golsp/...
	go get -u github.com/saibing/bingo
  go get -u github.com/cweill/gotests/...
  go get -u github.com/fatih/gomodifytags
}

option=$(dialog --title " Hugo 一键安装自动脚本" \
	--checklist "请输入:" 20 70 5 \
	"1" "Install shfmt" 0 \
	"2" "Install gofish package manager" 0 \
	"3" "Install go from official site" 0 \
	"4" "Install go tools" 0 \
	"5" "Install gogs" 0 \
	"6" "Setup go environment" 0 \
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
	setup_go_emacs
	;;
5)
	setup_gogs
	;;
6)
	setup_gogs_env
	;;
*)
	echo "Skipped!"
	;;
esac
