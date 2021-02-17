echo "==========================================================="
echo "installing deno environment for you..."
echo "==========================================================="

cd

while true; do
  read -r -p "    [1]Help [2]Official [3]Package Manager:  " opt
  case $opt in
    1)
      rustup do
      break
      ;;
    2)
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
      case ":${PATH}:" in
          *:"$HOME/.cargo/bin":*)
              ;;
          *)
              # Prepending path in case a system-installed rustc needs to be overridden
              export PATH="$HOME/.cargo/bin:$PATH"
              ;;
      esac
      echo "You can always enable rust with [EnvSetup/bash/custom/plugins/rust.plugin.sh]"
      break
      ;;
    3)
      cargo
      break
      ;;
    *)
      echo "Please answer 0, 1"
      ;;
  esac
done