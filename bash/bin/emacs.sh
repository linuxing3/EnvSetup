echo "==========================================================="
echo "installing emacs 26, another of the best editors"
echo "==========================================================="
sudo apt-get install -y emacs-nox ripgrep

read -p "Install the doom configuation[y/n]?" doom

if [ eq $doom "y"]; then
  cd
  echo "installing doom emacs"
  git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
  echo "Done with doom-emacs!"
else
  echo "Skipped installing doom emacs"
fi

read -p "Install the private doom configuation[y/n]?" private

if [ eq $private "y"]; then
  echo "installing private doom setting for linuxing3"
  cd
  git clone https://github.com/linuxing3/doom-emacs-private ~/.doom.d
  echo "Boostrap with doom install"
  cd ~/.emacs.d/bin
  ./doom install
else
  echo "Skipped installing private doom setting for linuxing3"
fi

doom=
private=
