# Openwrt management

## Build Openwrt

### With `github actions`

- 使用 GitHub Actions 云编译 OpenWrt

https://p3terx.com/archives/build-openwrt-with-github-actions.html

- ssh to your `github action ssh server`

优化了部分提示文案的显示逻辑，修改连接超时为 30 分钟，解决了失去控制的问题。

```
name: Ubuntu
on:
  watch:
    types: started
jobs:
  Ubuntu:
    runs-on: ubuntu-latest
    steps:
    - name: SSH connection to Actions
      uses: P3TERX/debugger-action@master
```
