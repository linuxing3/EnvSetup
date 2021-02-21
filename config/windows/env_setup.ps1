# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
#

# Unblock-File -Path %
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# 获取主目录
# (Env:USERPROFILE)
$homedir = [System.Environment]::GetEnvironmentVariable('USERPROFILE') + '\'
# 持久设置目录
[System.Environment]::SetEnvironmentVariable('HOME', $homedir, [System.EnvironmentVariableTarget]::Machine)

$setup_path = $homedir + '\EnvSetup\config\windows'
Write-Host "进入安装目录:" + $setup_path -ForegroundColor Green
Set-Location $setup_path

Write-Host "------------------------------------" -ForegroundColor Red
Write-Host "开始设置" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Red
Write-Host "[0] 设置电脑名称" -ForegroundColor Green
Write-Host "[1] 设置系统路径" -ForegroundColor Green
Write-Host "[2] 设置Emacs" -ForegroundColor Green
Write-Host "[3] 设置Packages包管理" -ForegroundColor Green
Write-Host "[4] 设置Powershell包管理" -ForegroundColor Green
Write-Host "[5] 设置nodejs路径" -ForegroundColor Green
Write-Host "[6] 设置go" -ForegroundColor Green
Write-Host "[7] 设置putty" -ForegroundColor Green
Write-Host "[8] 设置远程桌面" -ForegroundColor Green
Write-Host "[9] 设置Openssh" -ForegroundColor Green
Write-Host "[10] 设置Npc" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Red
$answer = Read-Host -Prompt "请选择:"
switch ($answer) {
  "0" {
    .\env_setup_default.ps1
  }
  "1" {
    .\env_setup_path.ps1
  }
  "2" {
    .\env_setup_emacs.ps1
  }
  "3" {
    .\env_setup_packages.ps1
  }
  "4" {
    .\env_setup_powershell_packages.ps1
  }
  "5" {
    .\env_setup_nodejs.ps1
  }
  "6" {
    .\env_setup_go.ps1
  }
  "7" {
    .\env_setup_putty.ps1
  }
  "8" {
    .\env_setup_rdp.ps1
  }
  "9" {
    .\env_setup_ssh.ps1
  }
  "10" {
    .\env_setup_npc.ps1
  }
  Default {
    Write-Host "跳过!" -ForegroundColor Green
  }
}

Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "完成!" -ForegroundColor Green