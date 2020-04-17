# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.
alias v=nvim
alias vi=vim

alias fzfvim="vim \$(fzf)"
alias fzfgit="git checkout \$(git branch -r | fzf)"
alias fzfdir="cd \$(find * -type d | fzf)"

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --preview '(bat --theme zenburn {}) 2> /dev/null | head -500'"
export FZ_DEFAULT_COMMAND="fd --exclude={.git,.idea,.vscode,.sass-cache,node_modules,build} --type f"
