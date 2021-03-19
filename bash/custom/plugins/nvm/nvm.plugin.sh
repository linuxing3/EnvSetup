#!/usr/bin/env bash

nnmirror() {
	export NVM_NODEJS_ORG_MIRROR="https://unofficial-builds.nodejs.org/download/release"
}

# node stuff
export NVM_NODEJS_ORG_MIRROR="https://nodejs.org/dist"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# deno stuff
export DENO_INSTALL="$HOME/.deno"
export DVM_DIR="$HOME/.dvm"
export PATH="$DVM_DIR/bin:$DENO_INSTALL/bin:$PATH"
