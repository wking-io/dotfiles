#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "./utils.sh"

declare -r LOCAL_SHELL_CONFIG_FILE="$HOME/.zshrc"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_latest_stable_node() {

    # Install the latest stable version of Node
    # (this will also set it as the default).

    . $LOCAL_SHELL_CONFIG_FILE
      nvm install node
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n   nvm\n\n"

    brew_install "NVM" "nvm"
    install_latest_stable_node

}

main
