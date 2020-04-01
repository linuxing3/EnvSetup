# Skipping for snapd
# sudo apt install snapd
# snap install emacs --classic
echo "==========================================================="
echo "installing emacs 26, another of the best editors"
echo "==========================================================="
sudo apt-get install -y emacs-nox ripgrep

cd
echo "installing doom emacs"
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
echo "installing private doom setting for linuxing3"
git clone https://github.com/linuxing3/doom-emacs-private ~/.doom.d

echo "Boostrap doom emacs"
cd ~/.emacs.d/bin
./doom install