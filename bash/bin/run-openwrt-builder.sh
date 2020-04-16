docker run -itd \
    --name openwrt-build-env \
    -h P3TERX \
    -p 10022:22 \
    -v ~/openwrt:/home/user/openwrt \
    p3terx/openwrt-build-env:18.04
