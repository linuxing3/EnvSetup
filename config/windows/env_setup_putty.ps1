# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
# Usage: Script to set environment variables and putty themes
#

# Unblock-File -Path %
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# -----------------------------------------------------------------------------
# Seting Putty thmes
Write-Host "使用regedit添加putty主题"
$putty_themes=(Get-ChildItem 'C:\Users\Administrator\OneDrive\config\colors\putty\*.reg')
$putty_theme_reg='Registry::HKEY_CURRENT_USER\Software\SimonTatham\PuTTY\Sessions\Default%20Settings'
Write-Host "Add github theme for you" -ForegroundColor Red
regedit /s $putty_themes[11]
# Invoke-Command {reg import \\server\share\test.reg *>&1 | Out-Null}
$test_color=(Get-ItemProperty -Path $putty_theme_reg).Colour0
Write-Host "Colour0 is like this" $test_color -ForegroundColor Red

# -----------------------------------------------------------------------------
Write-Host "Add putty github theme, directly write to reg"
$theme_set=@{}
$theme_set["Colour0"]='62,62,62'
$theme_set["Colour1"]='201,85,0'
$theme_set["Colour2"]='244,244,244'
$theme_set["Colour3"]='244,244,244'
$theme_set["Colour4"]='63,63,63'
$theme_set["Colour5"]='62,62,62'
$theme_set["Colour6"]='62,62,62'
$theme_set["Colour7"]='102,102,102'
$theme_set["Colour8"]='151,11,22'
$theme_set["Colour9"]='222,0,0'
$theme_set["Colour10"]='7,150,42'
$theme_set["Colour11"]='135,213,162'
$theme_set["Colour12"]='248,238,199'
$theme_set["Colour13"]='241,208,7'
$theme_set["Colour14"]='0,62,138'
$theme_set["Colour15"]='46,108,186'
$theme_set["Colour16"]='233,70,145'
$theme_set["Colour17"]='255,162,159'
$theme_set["Colour18"]='137,209,236'
$theme_set["Colour19"]='28,250,254'
$theme_set["Colour20"]='255,255,255'
$theme_set["Colour21"]='255,255,255'

Write-Host "展示Github theme颜色"
$theme_set.keys | ForEach-Object {
    Write-Output "Key = $_" -ForegroundColor Green
    Write-Output "Value = $($theme_set[$_])" -ForegroundColor Blue
    Write-Output '----------' -ForegroundColor Green
}

Write-Host ""
$answer=(Read-Host -Prompt "是否写入颜色，回车继续")
if($answer==='y') {
  ForEach ($colour in $theme_set.Keys ) {
    Set-ItemProperty -Path $putty_theme_reg -Name $colour -Value $theme_set[$colour]
  }
  Write-Host "Putty主题设置成功" -ForegroundColor Green
} else {
  Write-Host "Putty主题设置未成功!" -ForegroundColor Red
}

Write-Host "------------------------------------" -ForegroundColor Green
