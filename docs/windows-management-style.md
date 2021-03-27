---
title: Windows运维
date: 2020-05-04T09:30:43-30:50
tags:
---

# Windows 10 Developer Machine Setup

This is the script for linuxing3 to setup a new dev box. You can modify the
scripts to fit your own requirements.

## Prerequisites

- A clean install of Windows 10 Pro

## How to Use

Download latest script here: https://github.com/linuxing3/EnvSetup

```bash
curl https://raw.githubusercontent.com/linuxing3/EnvSetup/master/install.sh >> env-setup.sh | chmod +x env-setup.sh | ./env-setup --install
```

### Optional

Import `Add_PS1_Run_as_administrator.reg` to your registry to enable context menu on the powershell files to run as Administrator.

### Run bootstrap-win.ps1 as Administrator

```powershell
bootstrap-win.ps1
```