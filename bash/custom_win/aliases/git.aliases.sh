#!/usr/bin/env bash

alias gco='git checkout'
alias gcob='git checkout -b'
alias gcoo='git fetch && git checkout'

alias gbr='git branch'
alias gbrd='git branch -d'
alias gbrD='git branch -D'

alias gmerge='git branch --merged'

alias gst='git status'
alias gaa='git add -A .'

alias gcm='git commit -m'
alias gaacm='git add -A . && git commit -m'
alias gcp='git cherry-pick'
alias gamend='git commit --amend -m'
alias gdev='git  !git checkout dev && git pull origin dev'
alias gstagi='git checkout staging && git pull origin staging'
alias gmastegit='git checkout master && git pull origin '

alias gpo='git push origin'
alias gpod='git push origin dev'
alias gpos='git push origin staging'
alias gpom='git push origin master'
alias gpoh='git push origin HEAD'

alias gpogm='git push origin gh-pages && git checkout master && git pull origin master && git rebase gh-pages && git push origin master && git checkout gh-pages'
alias gpomg='git git push origin master && git checkout gh-pages && git pull origin gh-pages && git rebase master && git push origin gh-pages && git checkout master'

alias gplo='git  pull origin'
alias gplod='git  pull origin dev'
alias gplos='git  pull origin staging'
alias gplom='git  pull origin master'
alias gploh='git  pull origin HEAD'

alias gls='git log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate'
alias gll='git log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'
