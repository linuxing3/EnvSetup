echo "==========================================================="
echo "installing emacs 26, another of the best editors"
echo "==========================================================="
sudo apt-get install -y emacs-nox ripgrep


install_doom_emacs() {
  cd
  echo "installing doom emacs"
  git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
  echo "Done with doom-emacs!"
}

install_doom_private() {
  echo "installing private doom setting for linuxing3"
  cd
  git clone https://github.com/linuxing3/doom-emacs-private ~/.doom.d
  echo "Boostrap with doom install"
  cd ~/.emacs.d/bin
  ./doom install
}

while true; do
  read -r -p "    Install [0]doom-emacs [1]private doom [2]both: " opt
  case $opt in
    0)
      install_doom_emacs
      break
      ;;
    1)
      install_doom_private
      break
      ;;
    2)
      install_doom_emacs
      install_doom_private
      break
      ;;
    *)
      echo "Please answer 0, 1 or 2"
      ;;
  esac
done
