
$version="0.21.1"

if ([Environment]::Is64BitProcess) {
  $binary_arch="amd64"
} else {
  $binary_arch="386"
}

function download_powershell() {
  $uri="https://github-production-release-asset-2e65be.s3.amazonaws.com/49609581/142d2280-5d5f-11ea-9cfe-fe02494447f7?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20200426%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200426T161157Z&X-Amz-Expires=300&X-Amz-Signature=15fec1f00c2de40b0298d132a2170575189fd168c69ccb68cfc643cfb55d2fbd&X-Amz-SignedHeaders=host&actor_id=577637&repo_id=49609581&response-content-disposition=attachment%3B%20filename%3DPowerShell-7.0.0-win-x86.msi&response-content-type=application%2Foctet-stream"
  $file "d:\powershell7.msi"
  Invoke-WebRequest -Uri $uri -OutFile $file
  d:\powershell7.msi
}


$fzf_base=Split-Path -Parent $MyInvocation.MyCommand.Definition

function check_fzf_binary () {
  Write-Host "  - Checking fzf executable ... " -NoNewline
  # 检查可执行文件
  $output=cmd /c $fzf_base\bin\fzf.exe --version 2>&1
  if (-not $?) {
    Write-Host "Error: $output"
    $binary_error="Invalid binary"
  } else {
    # 获取输出的第一个结果是版本号
    $output=(-Split $output)[0]
    if ($version -ne $output) {
      Write-Host "$output != $version"
      $binary_error="Invalid version"
    } else {
      Write-Host "$output"
      $binary_error=""
      return 1
    }
  }
  Remove-Item "$fzf_base\bin\fzf.exe"
  return 0
}

function download_fzf {
  param($file)
  Write-Host "Downloading bin/fzf ..."
  # 检测是否已经安装，如果是就退出
  if ("$version" -ne "alpha") {
    if (Test-Path "$fzf_base\bin\fzf.exe") {
      Write-Host "  - Already exists"
      if (check_fzf_binary) {
        return
      }
    }
  }
  # 如果没有目标文件夹，就新建一个
  if (-not (Test-Path "$fzf_base\bin")) {
    md "$fzf_base\bin"
  }
  # 如果创建失败，报错
  if (-not $?) {
    $binary_error="Failed to create bin directory"
    return
  }
  cd "$fzf_base\bin"
  # 选择合适的版本和链接地址
  if ("$version" -eq "alpha") {
    $url="https://github.com/junegunn/fzf-bin/releases/download/alpha/$file"
  } else {
    $url="https://github.com/junegunn/fzf-bin/releases/download/$version/$file"
  }
  # 下载fzf文件
  $temp=$env:TMP + "\fzf.zip"
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  (New-Object Net.WebClient).DownloadFile($url, $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("$temp"))
  # 如果下载成功，解压后删除压缩文件
  if ($?) {
    (Expand-Archive -Path $temp -DestinationPath .); (Remove-Item $temp)
  } else {
    $binary_error="Failed to download with powershell"
  }
  # 测试是否有可执行文件
  if (-not (Test-Path fzf.exe)) {
    $binary_error="Failed to download $file"
    return
  }
  check_fzf_binary >$null
}

download_fzf "fzf-$version-windows_$binary_arch.zip"

Write-Host 'For more information, see: https://github.com/junegunn/fzf'

