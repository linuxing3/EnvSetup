# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

# For example: add yourself some shortcuts to projects you often work on.
#

alias reload="source ~/.bashrc"
alias db="cd ~/Dropbox"
alias ws="cd ~/workspace"
alias bashconfig="emacsclient -c ~/.bashrc"
alias ohmybash="emacsclient -c ~/.oh-my-bash"

function search() {
  sed -n "1,\$p" $1 | grep -m10 -nF $2
}

function init-org-home-directory() {

  today=$(date +%Y-%m-%d-%s)
  cd
  tar cvf "org.$today.tar" org
  rm -rf ~/org
  mkdir -p org
  cd org
  for dir in attach journal roam brain
  do
    rm -f $dir
    mkdir -p $dir
  done

  for file in inbox links snippets tutorials projects
  do
    rm -f "$file.org"
    touch "$file.org"
    echo "* $file org file created $today\n" >> "$file.org" 
  done
  echo "Done! Created org home directory!"
}
