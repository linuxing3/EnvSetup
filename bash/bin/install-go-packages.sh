#!/usr/bin/env bash
#install go packages
# check arch, if i686, download 32 bit

OS=linux
MYARCH=$(arch)
if [ $MYARCH == "i686" ]; then
	ARCH="386"
else
	ARCH="amd64"
fi

GO_VERSION=1.14.2
SHFMT_VERSION=3.1.1

install_shfmt() {
	wget -O shfmt "https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_${OS}_${ARCH}"
	sudo mv shfmt /usr/local/bin/
	type shfmt
}

install_gofish() {
	curl -fsSL https://raw.githubusercontent.com/fishworks/gofish/master/scripts/install.sh | bash
}
install_go() {
	wget https://dl.google.com/go/go$GO_VERSION.$OS-$ARCH.tar.gz
	sudo tar -C /usr/lib -xzf go$GO_VERSION.$OS-$ARCH.tar.gz
	type go
	if [ ! -d "$HOME/workspace/go-project" ]; then
		mkdir -p "$HOME/workspace/go-project"
	fi
	export GO111MODULE="on"
	export GOROOT=/usr/lib/go
	export GOPATH=$HOME/workspace/go-project
	export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
	echo "You can enalbe go environment with ggg!!!"
}

option=$(dialog --title " Hugo 一键安装自动脚本" \
	--checklist "请输入:" 20 70 5 \
	"1" "Install shfmt" 0 \
	"2" "Install gofish package manager" 0 \
	"3" "Install go from official site" 0 \
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
*)
	echo "Skipped!"
	;;
esac
