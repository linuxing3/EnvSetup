#!/bin/bash
# Copyright 2019 the Deno authors. All rights reserved. MIT license.
# Copyright 2020 justjavac. All rights reserved. MIT license.
# TODO(everyone): Keep this script simple and easily auditable.


install_dvm() {

  # curl -fsSL https://deno.land/x/dvm/install.sh | sh
  # source $HOME/.bash_profile
  # dvm list

  set -e

  if [ "$(uname -m)" != "x86_64" ]; then
    echo "Error: Unsupported architecture $(uname -m). Only x64 binaries are available." 1>&2
    exit 1
  fi

  if ! command -v unzip >/dev/null; then
    echo "Error: unzip is required to install Dvm (see: https://github.com/justjavac/dvm#unzip-is-required)." 1>&2
    exit 1
  fi

  if [ "$OS" = "Windows_NT" ]; then
    target="x86_64-pc-windows-msvc"
  else
    case $(uname -s) in
    Darwin) target="x86_64-apple-darwin" ;;
    *) target="x86_64-unknown-linux-gnu" ;;
    esac
  fi

  dvm_uri="https://cdn.jsdelivr.net/gh/justjavac/dvm_releases/dvm-${target}.zip"

  deno_install="${DENO_INSTALL:-$HOME/.deno}"
  dvm_dir="${DVM_DIR:-$HOME/.dvm}"
  dvm_bin_dir="$dvm_dir/bin"
  exe="$dvm_bin_dir/dvm"

  if [ ! -d "$dvm_bin_dir" ]; then
    mkdir -p "$dvm_bin_dir"
  fi

  curl --fail --location --progress-bar --output "$exe.zip" "$dvm_uri"
  cd "$dvm_bin_dir"
  unzip -o "$exe.zip"
  chmod +x "$exe"
  rm "$exe.zip"

  case $SHELL in
    /bin/zsh) shell_profile=".zshrc" ;;
    *) shell_profile=".bashrc" ;;
  esac

  if [ ! $DENO_INSTALL ];then
      command echo "export DENO_INSTALL=\"$deno_install\"" >> "$HOME/$shell_profile"
      command echo "export PATH=\"\$DENO_INSTALL/bin:\$PATH\"" >> "$HOME/$shell_profile"
  fi

  if [ ! $DVM_DIR ];then
      command echo "export DVM_DIR=\"$dvm_dir\"" >> "$HOME/$shell_profile"
      command echo "export PATH=\"\$DVM_DIR/bin:\$PATH\"" >> "$HOME/$shell_profile"
  fi

  echo "Dvm was installed successfully to $exe"
  if command -v dvm >/dev/null; then
    echo "Run 'dvm --help' to get started"
  else
    echo "Reopen your shell, or run 'source $HOME/$shell_profile' to get started"
  fi
}

echo "==========================================================="
echo "installing deno environment for you..."
echo "==========================================================="

cd

while true; do
  read -r -p "    [1] dvm [2] official [3] Packages :  " opt
  case $opt in
    1)
      install_dvm
      break
      ;;
    2)
      curl -fsSL https://deno.land/x/install/install.sh | sh
      case ":${PATH}:" in
          *:"$HOME/.deno/bin":*)
              ;;
          *)
              # Prepending path in case a system-installed rustc needs to be overridden
              export PATH="$HOME/.deno/bin:$PATH"
              ;;
      esac
      break
      ;;
    3)
      echo "installing trex, a package manager"
      deno install -A --unstable -n trex --no-check https://deno.land/x/trex/cli.ts
      echo "installing vno, a vue builder"
      deno install --allow-net --unstable https://deno.land/x/vno/install/vno.ts
      echo "install denon, a app monitor"
      deno install -qAf --unstable https://deno.land/x/denon/denon.ts
      break
      ;;
    *)
      echo "Please choose a correct answer"
      ;;
  esac
done