#!/usr/bin/bash

skripts="$(ls ../beloWMScripting | sed 's/install-script.sh//p')"

if ! [ -d $HOME/.local/scripts ]; then
    mkdir -p $HOME/.local/scripts
fi

chmod +x ${skripts}
cp ${skripts} $HOME/.local/scripts
