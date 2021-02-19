# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11

# Unblock-File -Path %
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$homedir = [System.Environment]::GetEnvironmentVariable('USERPROFILE') + '\'
[System.Environment]::SetEnvironmentVariable('HOME', $homedir, [System.EnvironmentVariableTarget]::Machine)

function CheckCommand($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

if (CheckCommand -cmdname 'choco') {
    Write-Host "Choco已安装." -ForegroundColor Green
}
else {
    Write-Host ""
    Write-Host "安装Chocolate for Windows..." -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Write-Host ""
Write-Host "安装其他应用..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "用于开发环境" -ForegroundColor Yellow

$fonts = "hackfont", "firacode", "sourcecodepro", "cascadiacode", "source", "robotofonts"

$libs = 'git', 'nodejs', 'python', 'golang', 'rust', 'deno'

$tools = '7zip.install', 'googlechrome', 'potplayer', 'dotnetcore-sdk', 'ffmpeg', 'wget', 'openssl.light'

$ssh_tools = 'emacs', 'greprip', 'vim-tux.install', 'neovim', 'putty', 'WinSCP', 'filezilla', 'lightshot.install'

$vscode = 'vscode.install', 'vscode-powershell', 'vscode-python', 'vscode-java', 'vscode-icons', 'vscode-prettier', 'vscode-vsonline', 'vscode-chrome'
'vscode-eslint', 'vscode-gitlens', 'vscode-settingssync'

$misc = 'sysinternals', 'dotpeek', 'linqpad', 'fiddler', 'beyondcompare'

$teams = 'microsoft-teams.install', 'teamviewer', 'github-desktop'

$vms = 'vagrant', 'virtualbox'

$packages = $libs, $fonts, $tools, $ssh_tools, $vscode, $misc, $teams, $vms

foreach ($module in $packages) {
    $prompt = "是否设置" + $module + "?[Y/N]"
    $answer = Read-Host -Prompt $prompt
    if ($answer -eq "y" || $answer -eq "Y") {
        foreach ($app in $module) {
            
            if (CheckCommand -cmdname $app) {
                Write-Host $app "已安装，跳过!"
            } else {
                Write-Host "开始安装!" $app -ForegroundColor Green
                # choco install -y $app
            }
            
        }
    }
    else {
        Write-Host "跳过!" -ForegroundColor Green
    }
}

Write-Host "------------------------------------" -ForegroundColor Green
