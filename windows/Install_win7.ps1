# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
# Unblock-File -Path .\Install_win7.ps1
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

function Check-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# -----------------------------------------------------------------------------
$computerName = Read-Host 'Input your Office Desktop Name'
Write-Host "Renaming this computer to: " $computerName  -ForegroundColor Yellow
Rename-Computer -NewName $computerName
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Disable Sleep on AC Power..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Powercfg /Change monitor-timeout-ac 20
Powercfg /Change standby-timeout-ac 0

Write-Host "Disable default keybindings:" -ForegroundColor Yellow
New-ItemProperty -Path "HKCU:Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisableHotkeys" -Value "F" -PropertyType "String"

# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Changing ENV Variable: [PATH]" $computerName  -ForegroundColor Yellow
Write-Host "------------------------------------" -ForegroundColor Green
$oldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
Write-Host "Old Value:" $oldPath  -ForegroundColor Green
Write-Host ""
Write-Host "------------------------------------" -ForegroundColor Green
$newPath = "C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files\ATI Technologies\ATI.ACE\Core-Static;C:\Program Files\Intel\iCLS Client\;C:\Program Files\Intel\Intel(R) Management Engine Components\DAL;C:\Program Files\Intel\Intel(R) Management Engine Components\IPT;C:\Program Files\NVIDIA Corporation\PhysX\Common;C:\Program Files\YUGUO;C:\ProgramData\chocolatey\bin;C:\Program Files\LLVM\bin;C:\Program Files\Git\cmd;C:\Program Files\Git\mingw32\bin;C:\Program Files\Git\usr\bin;C:\Users\wjb\AppData\Local\Programs\Microsoft VS Code\bin;C:\Program Files\Microsoft VS Code\bin;C:\Users\wjb\AppData\Roaming\nvm;C:\Program Files\nodejs;C:\Program Files\Yarn\bin\;C:\Users\wjb\AppData\Local\Yarn\bin;C:\Program Files\nodejs\node_modules\.bin;C:\Program Files\nodejs\node_modules\windows-build-tools\node_modules\.bin;C:\Users\wjb\AppData\Roaming\nvm\v10.15.3\node_modules\npm\node_modules\npm-lifecycle\node-gyp-bin;B:\app\openjdk\11.0.5.10\bin;B:\app\Vagrant\bin;D:\var\sbin;D:\var\anaconda3;D:\var\anaconda3\Scripts;D:\var\ctags58;D:\var\curl\bin;D:\var\pt;D:\var\rsync;D:\var\subl;D:\var\UltraISO;D:\Dropbox\bin;D:\Dropbox\PortableApps\ConsolePortable;D:\Dropbox\PortableApps\DM2Portable;D:\Dropbox\PortableApps\Explorer++Portable;D:\Dropbox\PortableApps\Notepad2-modPortable;D:\Dropbox\PortableApps\PuTTYPortable;D:\Dropbox\PortableApps\WinSCPPortable;C:\Python38\Scripts\;C:\Python38\;C:\Users\wjb\.windows-build-tools\python27\;C:\Users\wjb\.windows-build-tools\python27\Scripts;D:\Dropbox\bin"
Write-Host "New Value:" $newPath  -ForegroundColor Green

Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath

Write-Host ""
Write-Host "------------------------------------" -ForegroundColor Green
($env:path).split(";")

Write-Host "Changing ENV Variable: [HOME] " $computerName  -ForegroundColor Yellow
[System.Environment]::SetEnvironmentVariable('HOME','C:\Users\Wjb',[System.EnvironmentVariableTarget]::Machine)

if (Check-Command -cmdname 'choco') {
    Write-Host "Choco is already installed, skip installation."
}
else {
    Write-Host ""
    Write-Host "Installing Chocolate for Windows..." -ForegroundColor Green
    Write-Host "------------------------------------" -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Write-Host ""
Write-Host "Installing Applications..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "For development environment" -ForegroundColor Yellow

if (Check-Command -cmdname 'git') {
    Write-Host "Git is already installed, checking new version..."
    #choco upgrade git -y
}
else {
    Write-Host ""
    Write-Host "Installing Git for Windows..." -ForegroundColor Green
    choco install git -y
}

if (Check-Command -cmdname 'node') {
    Write-Host "Node.js is already installed, checking new version..."
    #choco upgrade nodejs -y
}
else {
    Write-Host ""
    Write-Host "Installing Node.js..." -ForegroundColor Green
    choco install nodejs -y
}

if (Check-Command -cmdname 'conda') {
    Write-Host "python is already installed, checking new version..."
    #choco upgrade anaconda3 -y
}
else {
    Write-Host ""
    Write-Host "Installing python..." -ForegroundColor Green
    choco install anaconda3 -y
}

Write-Host "Installing fonts" -ForegroundColor Green
choco install hackfont -y
choco install firacode -y
choco install sourcecodepro -y
choco install cascadiacode -y
choco install source-han-sans-cn -y
choco install robotofonts -y

Write-Host "Installing tools" -ForegroundColor Green
choco install 7zip.install -y
choco install googlechrome -y
#choco install potplayer -y
#choco install dotnetcore-sdk -y
#choco install ffmpeg -y
choco install wget -y
#choco install openssl.light -y

Write-Host "Installing ssh tools" -ForegroundColor Green
choco install emacs greprip -y
choco install vim-tux.install -y
choco install spf13-vim -y

Write-Host "Installing vscode" -ForegroundColor Green
choco install vscode.install -y
choco install vscode-powershell -y
choco install vscode-python -y
choco install vscode-java -y
choco install vscode-icons -y
choco install vscode-prettier -y
choco install vscode-vsonline -y
choco install vscode-chrome-debug -y
choco install vscode-eslint -y
choco install vscode-gitlens -y
choco install vscode-settingssync -y

# choco install sysinternals -y
# choco install dotpeek -y
# choco install linqpad -y
# choco install fiddler -y
# choco install beyondcompare -y

Write-Host "Installing ssh tools" -ForegroundColor Green
choco install putty -y
choco install WinSCP -y
choco install filezilla -y
# choco install lightshot.install -y

Write-Host "Installing team tools" -ForegroundColor Green
# choco install microsoft-teams.install -y
# choco install teamviewer -y
# choco install github-desktop -y
choco install vagrant -y
choco install virtualbox -y
choco install nodejs -y
choco install python -y

pip install --user pipenv

Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to restart computer."
Restart-Computer
