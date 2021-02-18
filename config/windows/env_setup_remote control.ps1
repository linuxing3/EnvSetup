# !/usr/bin/env powershell
#
# Author: linuxing3<linuxing3@qq.com>
# Copyrigtht: MIT
# Date: 2020-05-11
#
# Unblock-File -Path %
Write-Host "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# 1. simple way
# (Start-Process -FilePath "msiexec.exe" -ArgumentList "/silent" -Wait -Passthru).ExitCode
$setup = Start-Process "setup.exe" -ArgumentList "/s" -Wait
if ($setup.exitcode -eq 0) {
    write-host "Successfully installed" 
}

# 2. remote download and install
$url = ''
Invoke-WebRequest $url -OutFile 'c:\temp_installer.exe' -UseBasicParsing

$computerName = 'xingxiaorui'
Invoke-Command -ComputerName $computerName -ScriptBlock { 
    Start-Process c:\temp_installer.exe -ArgumentList '/silent' -Wait
}

# 3. choco install
# choco install -y $PackageName

git clone https://github.com/Chronial/wsl-sudo.git
# alias wudo="python3 wsl-sudo/wsl-sudo.py"
wudo cmd choco install -y radmin-server
# Usage examples:
# $ wudo cmd  # open elevated standard command prompt
# $ wudo bash  # open elevated shell
# $ wudo vim /mnt/c/Windows/System32/Drivers/etc/hosts
# $ wudo cp foo.txt /mnt/c/Program Files/
# $ wudo regedit

# 4. with user input
# Install Application 1
Show-InstallationProgress "Installing Application 1..."
Execute-Process -FilePath "setup1.exe" -Arguments "/S"
# Install Application 2
Show-InstallationProgress "Installing Application 2..."
Execute-Process -FilePath "setup2.exe" -Arguments "/S"
# Get Input from user
$userResponse = Show-DialogBox -Title "Installation Notice" -Text "Do you wish to continue installing the additional applications?" -Buttons "YesNo" -Icon "Question"
If ($userResponse -eq "Yes") {
    # Install Application 3
    Show-InstallationProgress "Installing Application 3..."
    Execute-Process -FilePath "setup3.exe" -Arguments "/S"
}