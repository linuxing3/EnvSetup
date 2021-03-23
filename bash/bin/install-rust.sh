#!/usr/bin/env sh

install_binserve() {
  wget https://github.com/mufeedvh/binserve/releases/download/v0.1.0/binserve-v0.1.0-x86_64-unknown-linux-gnu -O /usr/local/bin/binserve
}

install_meilisearch() {
  curl -L https://install.meilisearch.com | sh
  mv meilisearch /usr/local/bin/
  echo "Starting meilisearch"
  nohup meilisearch &
  echo "Initialize the index with movie dataset"
  curl -L 'https://bit.ly/2PAcw9l' -o movies.json
  curl -i -X POST 'http://127.0.0.1:7700/indexes' --data '{ "name": "Movies", "uid": "movies" }'
  rm movies.json
}

install_bottom() {
  curl -LO https://github.com/ClementTsang/bottom/releases/download/0.5.7/bottom_0.5.7_amd64.deb
  sudo dpkg -i bottom_0.5.7_amd64.deb
  rm bottom_0.5.7_amd64.deb
}

install_gdbgui() {
  wget https://github.com/cs01/gdbgui/releases/download/v0.14.0.2/gdbgui_linux.zip
  unzip ./gdbgui_linux.zip
  chmod +x gdbgui
  mv gdbgui /usr/local/bin/
  rm ./gdbgui_linux.zip
}


echo "==========================================================="
echo "installing rust environment for you..."
echo "==========================================================="

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cd

while true; do
  read -r -p "    [1]Help [2]Official [3]Package Manager [4]Examples:  " opt
  case $opt in
    1)
      rustup doc
      break
      ;;
    2)
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
      case ":${PATH}:" in
          *:"$HOME/.cargo/bin":*)
              ;;
          *)
              # Prepending path in case a system-installed rustc needs to be overridden
              export PATH="$HOME/.cargo/bin:$PATH"
              ;;
      esac
      echo "You can always enable rust with [EnvSetup/bash/custom/plugins/rust.plugin.sh]"
      break
      ;;
    3)
      cargo
      break
      ;;
    4)
      install_binserve
      install_meilisearch
      break
      ;;
    *)
      echo "Please answer 0, 1"
      ;;
  esac
done
