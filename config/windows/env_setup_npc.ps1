# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
#
# Unblock-File -Path %
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$npc_base='c:\lib\npc'

function download_npc($file) {
  Set-Location $npc_base
  # 测试是否有可执行文件
  if (Test-Path 'npc.exe') {
    # 如果已存在，就跳过
    $binary_error="npc.exe exists, skipping download!"
    Write-Host $binary_error -ForegroundColor Red
    return
  }
  # 如果没有目标文件夹，就新建一个
  if (-not (Test-Path $npc_base)) {
    Write-Host "makding npc directory ..."
    mkdir $npc_base
  }
  # 如果创建失败，报错
  if (-not $?) {
    $binary_error="Failed to create bin directory"
    Write-Host $binary_error
    return
  }
  $binary_error=""
  Write-Host "Downloading npc ..."
  # 下载npc文件
  $url="https://github.com/ehang-io/nps/releases/download/v0.26.9/$file"
  $temp="npc.tar.gz"
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  (New-Object Net.WebClient).DownloadFile($url, $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$temp"))
  # 如果下载成功，解压后删除压缩文件
  if ($?) {
    # (Expand-Archive -Path $temp -DestinationPath .); (Remove-Item $temp)
    $binary_error="Downloaded npc, please unzip it by yourself"
    tar -xvf $temp -C $npc_base
    Write-Host $binary_error -ForegroundColor Green
  } else {
    $binary_error="Failed to download npc"
    Write-Host $binary_error -ForegroundColor Red
  }
}

# 开始下载
download_npc "windows_386_client.tar.gz"

Write-Host 'For more information, see: https://github.com/ehang-io/nps'

# 创建配置文件
$config_file=$npc_base+'\npc.conf'
Set-Content -Path $config_file -Value @"
[common]
server_addr=xunqinji.top:8024
conn_type=tcp
vkey=123
[ssh]
mode=tcp
server_port=9080
target_addr=127.0.0.1:8080
"@

# 删除服务
$npcExists=Get-Service -Name Npc | Select-Object -Property Name
if ($npcExists -eq "Npc") {
  Remove-Service -Name "Npc"
}

# 安装启动服务
# New-Service -Name "Npc" -BinaryPathName $command
c:\lib\npc\npc.exe install -config c:\lib\npc\npc.conf

Set-Service -Name Npc -StartupType 'Automatic'

# Set-Service -Name Npc -Status Running
Start-Service Npc

# 检查是否成功
Get-Service -Name Npc

Write-Hot "------------------------------------" -ForegroundColor Green