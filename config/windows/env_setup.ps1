# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
#

# Unblock-File -Path %
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$homedir=[System.Environment]::GetEnvironmentVariable('USERPROFILE') + '\'
[System.Environment]::SetEnvironmentVariable('HOME', $homedir,[System.EnvironmentVariableTarget]::Machine)

$setup_path=$homedir + '\EnvSetup\config\windows'
Write-Host "进入安装目录:" + $setup_path -ForegroundColor Green
Set-Location $setup_path

Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "开始设置" -ForegroundColor Green
$answer = Read-Host -Prompt "是否设置系统路径?[Y/N]"
if ($answer -eq "y" || $answer -eq "Y") {
  .\env_setup_default.ps1
  .\env_setup_path.ps1
} else {
  Write-Host "跳过!" -ForegroundColor Green
}

Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "设置Emacs的参数" -ForegroundColor Green
$answer = Read-Host -Prompt "是否设置Emacs?[Y/N]"
if ($answer -eq "y" || $answer -eq "Y") {
  .\env_setup_emacs.ps1
} else {
  Write-Host "跳过!" -ForegroundColor Green
}

Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "设置Packages包管理" -ForegroundColor Green
$answer = Read-Host -Prompt "是否设置常用软件包?[Y/N]"
if ($answer -eq "y" || $answer -eq "Y") {
  .\env_setup_packges.ps1
} else {
  Write-Host "跳过!" -ForegroundColor Green
}

Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "设置Packages包管理" -ForegroundColor Green
$answer = Read-Host -Prompt "是否设置Powershell包?[Y/N]"
if ($answer -eq "y" || $answer -eq "Y") {
  .\env_setup_powershell_packges.ps1
} else {
  Write-Host "跳过!" -ForegroundColor Green
}

Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "设置nodejs" -ForegroundColor Green
$answer = Read-Host -Prompt "是否设置Nodejs?[Y/N]"
if ($answer -eq "y" || $answer -eq "Y") {
  .\env_setup_nodejs.ps1
} else {
  Write-Host "跳过!" -ForegroundColor Green
}

Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "设置nodejs" -ForegroundColor Green
$answer = Read-Host -Prompt "是否设置go?[Y/N]"
if ($answer -eq "y" || $answer -eq "Y") {
  .\env_setup_go.ps1
} else {
  Write-Host "跳过!" -ForegroundColor Green
}

Write-Host "设置putty" -ForegroundColor Green
$answer = Read-Host -Prompt "是否设置Putty?[Y/N]"
if ($answer -eq "y" || $answer -eq "Y") {
  .\env_setup_putty.ps1
} else {
  Write-Host "跳过!" -ForegroundColor Green
}

Write-Host "设置rdp" -ForegroundColor Green
$answer = Read-Host -Prompt "是否设置远程桌面?[Y/N]"
if ($answer -eq "y" || $answer -eq "Y") {
  .\env_setup_rdp.ps1
} else {
  Write-Host "跳过!" -ForegroundColor Green
}

Write-Host "设置Openssh" -ForegroundColor Green
$answer = Read-Host -Prompt "是否设置Openssh?[Y/N]"
if ($answer -eq "y" || $answer -eq "Y") {
  .\env_setup_openssh.ps1
} else {
  Write-Host "跳过!" -ForegroundColor Green
}

$setup_path=$homedir
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "完成!" -ForegroundColor Green