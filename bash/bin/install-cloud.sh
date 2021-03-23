#!/usr/bin/env bash
# Copyright 2019 linuxing3. All rights reserved. MIT license.
# TODO(everyone): Keep this script simple and easily auditable.


install_heroku_cli() {
    echo "On windows download:"
    echo "https://cli-assets.heroku.com/heroku-x64.exe"
    curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
	echo "heroku login to start"
	echo "For manual install, run:"
	echo "wget https://cli-assets.heroku.com/heroku-linux-x64.tar.gz"
	echo "tar -xvf heroku-linux-x64.tar.gz"
	echo "cp heroku-linux-x64/heroku-cli /usr/local/bin/"
	echo "rm heroku-linux-x64.tar.gz"
	echo "rm -rf heroku-linux-x64"
}

install_vercel_cli() {
	npm i -g vercel
}

install_gcloud_cli() {
    echo "Preparing ..."
	echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
	sudo apt-get install apt-transport-https ca-certificates gnupg
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
	echo "Installing google cloud sdk toolchain"
	sudo apt-get update && sudo apt-get install google-cloud-sdk google-cloud-sdk-app-engine-go google-cloud-sdk-app-engine-python google-cloud-sdk-app-engine-python-extras
	echo "Done!"
	gcloud init
	echo "On windows, download"
	echo "https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe"
}

install_netlify_cli() {
	npm install netlify-cli -g
	echo "netlify login to start"
}

echo "==========================================================="
echo "installing cloud development environment for you..."
echo "==========================================================="

cd

while true; do
  read -r -p "    [1] Heroku [2] vercel [3] gcloud [4] netlify :  " opt
  case $opt in
    1)
      install_heroku_cli
      break
      ;;
    2)
      install_vercel_cli
      break
      ;;
    3)
      install_gcloud_cli
      break
      ;;
    4)
      install_netlify_cli
      break
      ;;
    *)
      echo "Please choose a correct answer"
      ;;
  esac
done
