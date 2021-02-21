# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
#
# Unblock-File -Path %
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$home_path = Resolve-Path '~/OneDrive'

New-PSDrive -Name Vault -PSProvider FileSystem -Root $home_path

Get-PSDrive -PSProvider FileSystem

Set-Location Vault:

Set-Location "~/"

Remove-PSDrive -Name Vault

Write-Host "------------------------------------" -ForegroundColor Green