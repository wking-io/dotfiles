#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

./xcode.sh
./homebrew.sh
./zsh.sh
./nvm.sh


./browsers.sh
./git.sh
./php.sh
./yarn.sh
./vscode.sh
./apps.sh

./cleanup.sh
