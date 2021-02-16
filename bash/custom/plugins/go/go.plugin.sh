# set go environment
#
ggg() {
	if [ -e /usr/lib/go/bin/go ]; then
		export GOROOT=/usr/lib/go
	elif [ -e /usr/local/bin/go/bin/go ]; then
		export GOROOT=/usr/local/bin/go
	elif [ -e $HOME/.go/bin/go ]; then
		export GOROOT=$HOME/.go/bin/go
	fi
	if [ ! -d "$HOME/go/src/github.com" ]; then
		mkdir -p "$HOME/go/src/github.com"
	fi
	export GO111MODULE=on
	export GOPATH=$HOME/go
	export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
}

ggg
