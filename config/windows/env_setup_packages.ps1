# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11

# Unblock-File -Path %

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

function convert_packages_to_json() {
    $fonts = "hackfont", "firacode", "sourcecodepro", "cascadiacode", "source", "robotofonts"
    $libs = 'git', 'nodejs', 'python', 'golang', 'rust', 'deno'
    $tools = '7zip.install', 'googlechrome', 'potplayer', 'dotnetcore-sdk', 'ffmpeg', 'wget', 'openssl.light'
    $ssh_tools = 'emacs', 'greprip', 'vim-tux.install', 'neovim', 'putty', 'WinSCP', 'filezilla', 'lightshot.install'
    $vscode = 'vscode.install', 'vscode-powershell', 'vscode-python', 'vscode-java', 'vscode-icons', 'vscode-prettier', 'vscode-vsonline', 'vscode-chrome', 'vscode-eslint', 'vscode-gitlens', 'vscode-settingssync'
    $misc = 'sysinternals', 'dotpeek', 'linqpad', 'fiddler', 'beyondcompare'
    $teams = 'microsoft-teams.install', 'teamviewer', 'github-desktop'
    $vms = 'vagrant', 'virtualbox'
    $packagesArray = @(
        @{name = "libs"; values = $libs },
        @{name = "fonts"; values = $fonts },
        @{name = "tools"; values = $tools },
        @{name = "ssh_tools"; values = $ssh_tools },
        @{name = "vscode"; values = $vscode },
        @{name = "misc"; values = $misc },
        @{name = "teams"; values = $teams },
        @{name = "vms"; values = $vms }
    )
    Set-Content -Path .\packages.json -Value ($packagesArray | ConvertTo-Json)
}


function install_packages {
    Write-Host ""
    Write-Host "安装其他应用..." -ForegroundColor Green
    Write-Host "用于开发环境" -ForegroundColor Yellow
    Write-Host "------------------------------------" -ForegroundColor Green

    $packagesObject = (Get-Content -Path .\packages.json | ConvertFrom-Json)

    foreach ($package in $packagesObject) {
        Write-Host "------------------------------------" -ForegroundColor Green
        Write-Host "开始安装$($package.name)" -ForegroundColor Green
        Write-Host "包括$($package.values)..." -ForegroundColor Green
        Write-Host "------------------------------------" -ForegroundColor Green
        $answer = Read-Host -Prompt "确认安装？ [Y/N]"
        if ($answer -eq "y") {
            foreach ($app in $package.values) {
                Write-Host "开始安装$($app)..." -ForegroundColor Green
                choco install -y $app
            }
        }
    }
    
}

$answer = Read-Host -Prompt "是否开始准备开发常用软件？ [Y/N]"
if ($answer -eq "y") {
    convert_packages_to_json
}

$answer = Read-Host -Prompt "是否开始安装开发常用软件？ [Y/N]"
if ($answer -eq "y") {
    install_packages
}

Write-Host "------------------------------------" -ForegroundColor Green
