echo "==========================================================="
echo "installing flutter environment for you..."
echo "==========================================================="


setup_flutter_env() {
  echo "Setting the flutter path"
  case ":${PATH}:" in
      *:"$HOME/.flutter/bin":*)
          ;;
      *)
          # Prepending path in case a system-installed rustc needs to be overridden
          export PATH="$HOME/.flutter/bin:$PATH"
          ;;
  esac
}

echo ""
echo "==========================================================="
cd
while true; do
  read -r -p "    [1]git [2]official [3]doctor [4]web:  " opt
  case $opt in
    1)
      echo "Cloning the repository"
      git clone https://github.com/flutter/flutter.git -b stable ~/.flutter
      setup_flutter_env
      break
      ;;
    2)
      echo "Downloading the install package"
      wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_1.22.6-stable.tar.xz
      echo "Extrating the files to ~/.flutter"
      tar -C ~/.flutter -xzf flutter_linux_1.22.6-stable.tar.xz
      setup_flutter_env
      break
      ;;
    3)
      setup_flutter_env
      flutter doctor
      break
      ;;
    4)
      cd ~/.flutter
      echo "Check out the source:"
      git remote get-url origin
      flutter channel beta
      echo "Upgrading and enable web module:"
      flutter upgrade
      flutter config --enable-web
      flutter devices
      echo "Usage:"
      echo "     flutter create myapp"
      echo "     cd myapp"
      echo "     flutter run -d chrome"
      echo "     flutter build web"
      break
      ;;
    *)
      echo "Please offer correct answer"
      ;;
  esac
done