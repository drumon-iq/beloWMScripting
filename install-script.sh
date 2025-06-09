#!/usr/bin/bash

skripts="$(ls ../beloWMScripting | sed 's/install-script.sh//p;s/README.md//p;s/LICENSE//p')"
local_skripts="$HOME/.local/scripts"

if ! [ -d ${local_skripts} ]; then
    mkdir -p ${local_skripts}
fi

cp ${skripts} ${local_skripts}
cd ${local_skripts}
chmod +x ${skripts}
