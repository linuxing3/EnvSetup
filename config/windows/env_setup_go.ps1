# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
# Usage: Script to set environment variables and putty themes
#

$user_env_reg = 'Registry::HKEY_CURRENT_USER\Environment'

# Unblock-File -Path %
Write-Host "将为您设置系统可执行文件路径。如果出现错误，请先运行以下命令开启验证"

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$homedir=[System.Environment]::GetEnvironmentVariable('USERPROFILE')

# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "设置GOPATH和GOROOT " $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green
$go_path = $homedir + '\go'
Set-ItemProperty -Path $user_env_reg -Name 'GOPATH' -Value $go_path
Write-Host $Env:GOPATH -ForegroundColor Green

$go_root_path = 'B:\lib\go', 'C:\lib\go', 'D:\lib\go', 'D:\lib\go', 'B:\Go',   'C:\Go', 'D:\Go', 'E:\Go', 'C:\Program Files\Go'

foreach ($path in $go_root_path) {
  if ( Test-Path -Path $path -PathType Container ) {
    Set-ItemProperty -Path $user_env_reg -Name 'GOROOT' -Value $path
    Write-Host $Env:GOROOT -ForegroundColor Green
    return 
  }
}


Write-Host "-------------------------------------------" -ForegroundColor Green
Write-Host "安装go tools--------------------------------" -ForegroundColor Green

$go_tools = 'goimport', 'gorename', 'guru'
foreach ($pkg in $go_tools) {
  go get golang.org/x/tools/cmd/$pkg
}
go get -u golang.org/x/tools/...
go get golang.org/x/tools/cmd/gopls
go get github.com/spf13/cobra/cobra
go get github.com/go-delve/delve/cmd/dlv