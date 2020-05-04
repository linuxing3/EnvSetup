echo "==========================================================="
echo "installing node environment for you..."
echo "==========================================================="

cd

echo "installing nvm"
# install 10/11 is not availabe in stretch
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
# curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
# sudo apt-get udpate
# sudo apt-get install -y nodejs
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

while true; do
  read -r -p "    Install from [0]unofficial [1]official:  " opt
  case $opt in
    0)
      echo "update NVM_NODEJS_ORG_MIRROR to https://unofficial-builds.nodejs.org/download/release"
      export NVM_NODEJS_ORG_MIRROR="https://unofficial-builds.nodejs.org/download/release"
      break
      ;;
    1)
      echo "use default NVM_NODEJS_ORG_MIRROR https://nodejs.org/dist"
      break
      ;;
    *)
      echo "Please answer 0, 1"
      ;;
  esac
done

echo "Testing nvm dir exists"
echo "If you can't run nvm, you may update sh with:"
echo "source ~/.bashrc"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

echo "installing latest"
nvm install node

echo "installing other node packages"
npm i -g yarn
echo "npm i -g httpserver serve pm2"
echo "npm i -g typescript"
echo "npm i -g prettier netlify-cli @vue/cli"
