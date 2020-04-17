
# set PATH so it includes user's bash custom bin if it exists
if [[ ! "$PATH" == "*/EnvSetup/bash/bin*" ]]; then
    export PATH="$HOME/EnvSetup/bash/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [[ ! "$PATH" == "*/EnvSetup/bin*" ]]; then
    export PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's local private bin if it exists
if [[ ! "$PATH" == "*/EnvSetup/.local/bin*" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes user's dropbox bin if it exists
if [[ ! "$PATH" == "*/EnvSetup/Dropbox/bin*" ]]; then
    export PATH="$HOME/Dropbox/bin:$PATH"
fi

