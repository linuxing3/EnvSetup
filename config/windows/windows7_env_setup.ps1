# If you can not execute this script, please set policy like below
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

Unblock-File -Path .\windows7_env_setup_path.ps1
Unblock-File -Path .\windows7_env_setup_packages.ps1

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# Setting path
.\windows7_env_setup_path.ps1

# Setting packages
.\windows7_env_setup_packages.ps1

# Setting up others
