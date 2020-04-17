
if [[ ! "$PATH" == "*~/EnvSetup/bash/bin*" ]]; then
    export PATH="~/EnvSetup/bash/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [[ ! "$PATH" == "*~/bin*" ]]; then
    export PATH="~/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [[ ! "$PATH" == "*~/.local/bin*" ]]; then
    export PATH="~/.local/bin:$PATH"
fi

