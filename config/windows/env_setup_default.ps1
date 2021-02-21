# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
#
# Unblock-File -Path %
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$homedir = [System.Environment]::GetEnvironmentVariable('USERPROFILE') + '\'
[System.Environment]::SetEnvironmentVariable('HOME', $homedir, [System.EnvironmentVariableTarget]::Machine)

function setup_default () {
    # -----------------------------------------------------------------------------
    $computerName = Read-Host '输入新的计算机名称'
    Write-Host "将本机重命名为: " $computerName  -ForegroundColor Yellow
    Rename-Computer -NewName $computerName
    # -----------------------------------------------------------------------------
    Write-Host ""
    Write-Host "取消休眠功能" -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    Powercfg /Change monitor-timeout-ac 20
    Powercfg /Change standby-timeout-ac 0
    # -----------------------------------------------------------------------------
    Write-Host ""
    Write-Host "添加关于本机到桌面" -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    $thisPCIconRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
    $thisPCRegValname = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" 
    $item = Get-ItemProperty -Path $thisPCIconRegPath -Name $thisPCRegValname -ErrorAction SilentlyContinue 
    if ($item) { 
        Set-ItemProperty  -Path $thisPCIconRegPath -name $thisPCRegValname -Value 0  
    } 
    else { 
        New-ItemProperty -Path $thisPCIconRegPath -Name $thisPCRegValname -Value 0 -PropertyType DWORD | Out-Null  
    } 
    # -----------------------------------------------------------------------------
    Write-Host ""
    Write-Host "移除Ddge的桌面图标" -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    $edgeLink = $env:USERPROFILE + "\Desktop\Microsoft Edge.lnk"
    Remove-Item $edgeLink
}
# -----------------------------------------------------------------------------
# To list all appx packages:
# Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName

function remove_unuseful() {
    Write-Host "删除不用的组件" -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    $uwpRubbishApps = @(
        "Microsoft.Messaging",
        "king.com.CandyCrushSaga",
        "Microsoft.BingNews",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.People",
        "Microsoft.WindowsFeedbackHub",
        "Microsoft.YourPhone",
        "Microsoft.MicrosoftOfficeHub",
        "Fitbit.FitbitCoach",
        "4DF9E0F8.Netflix")

    foreach ($uwp in $uwpRubbishApps) {
        Get-AppxPackage -Name $uwp | Remove-AppxPackage
    }
}


function setup_devmode () {
    Write-Host ""
    Write-Host "设置Windows 10 开发者模式." -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
}

setup_default

Write-Host "------------------------------------" -ForegroundColor Green