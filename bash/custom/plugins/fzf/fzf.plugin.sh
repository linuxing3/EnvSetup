#!/usr/bin/env bash

export FZF_DEFAULT_COMMAND='fdfind --type f'

export FZF_DEFAULT_OPTS="--height 40% --layout reverse --border\
--preview 'bat --style=numbers --color=always {} || cat {} || file {} || head -100 {}' "

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

