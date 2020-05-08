# set go environment
#
ggg() {
	if command -v "go" >/dev/null 2>&1; then
		if [ ! -d "$HOME/workspace/go-project" ]; then
			mkdir -p "$HOME/workspace/go-project"
		fi
		export GO111MODULE="on"
		export GOROOT=/usr/lib/go
		export GOPATH=$HOME/workspace/go-project
		export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
	fi
}
