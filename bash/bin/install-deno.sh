echo "==========================================================="
echo "installing deno environment for you..."
echo "==========================================================="

cd

while true; do
  read -r -p "    [1]dvm [2]official [3]Package Manager:  " opt
  case $opt in
    1)
      curl -fsSL https://deno.land/x/dvm/install.sh | sh
      source $HOME/.bash_profile
      dvm list
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
      echo "Please answer 0, 1"
      ;;
  esac
done