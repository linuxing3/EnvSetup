#!/usr/bin/env bash

export PATH="/home/vagrant/.local/bin:$PATH"
eval "$(/home/vagrant/.pyenv/bin/pyenv init -)"
eval "$(/home/vagrant/.pyenv/bin/pyenv virtualenv-init -)"
