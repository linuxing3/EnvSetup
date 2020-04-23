#!/usr/bin/env bash

export BASH_IT="$HOME/workspace/bash-it"

bashit_plugins="general git emacs vim ansible node npm"

# enable a thing
load_one() {
  file_type=$1
  just_the_name=$2
  single_type=$(echo "$file_type" | sed -e "s/completions$/completion/g" | sed -e "s/plugins$/plugin/g")
  file_to_enable="${BASH_IT}/${file_type}/available/${just_the_name}.${single_type}.bash"
  if [ -e $file_to_enable ]; then
    # echo "Bash-it Plugin enabled: $file_to_enable"
    source $file_to_enable
  fi
}

# Load Bash-it if possible
load_bash_it() {
    
    # Load composure first, so we support function metadata, such as cite, cite_about
    source "${BASH_IT}/lib/composure.bash"

    # Load libraries, but skip appearance (themes) for now
    LIB="${BASH_IT}/lib/*.bash"
    APPEARANCE_LIB="${BASH_IT}/lib/appearance.bash"
    for _bash_it_config_file in $LIB
        do
        if [ "$_bash_it_config_file" != "$APPEARANCE_LIB"  ]; then
            source "$_bash_it_config_file"
        fi
    done

    # Load built-in aliases, completion, plugins
    # for file_type in "aliases" "completion" "plugins"
    for file_type in "aliases" "plugins" "completion"
    do
        for just_the_name in $bashit_plugins
        do
            load_one $file_type $just_the_name
        done
    done

    # Load custom aliases, completion, plugins
    for file_type in "aliases" "completion" "plugins"
        do
        if [ -e "${BASH_IT}/${file_type}/custom.${file_type}.bash"  ]
            then
            source "${BASH_IT}/${file_type}/custom.${file_type}.bash"
        fi
    done

    unset file_type
    set +T
}

if [ -d "$BASH_IT" ]; then
    load_bash_it
fi
