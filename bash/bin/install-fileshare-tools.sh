#!/usr/bin/env bash

echo "==========================================================="
echo "安装文件传输工具"
echo "==========================================================="
cd

PS3='Please enter your choice: '
select opt in "croc" "minio" "ipfs"; do
    case $opt in
        "croc")
        curl https://getcroc.schollz.com | bash
        break
        ;;
        "minio")
        cd ~/EnvSetup/config/minio
        docker-compose -d up
        break
        ;;
        "ipfs")
        wget https://dist.ipfs.io/go-ipfs/v0.4.2/go-ipfs_v0.4.2_linux-amd64.tar.gz -O go-ipfs.tar.gz
        tar xvfz go-ipfs.tar.gz
        mv go-ipfs/ipfs /usr/local/bin/ipfs
        rm xvfz go-ipfs.tar.gz
        break
        ;;
        *)
        echo "Quit"
        break
        ;;
    esac
done
