#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_oh_my_zsh() {
    if cmd_exists "zsh"; then
        printf "\n" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" &> /dev/null
        #  └─ simulate the ENTER keypress
    else
        print_error "Zsh not installed yet"
    fi

    print_result $? "oh-my-zsh"    
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n   zsh & oh_my_zsh\n\n"

    brew_install "zsh" "zsh"
    install_oh_my_zsh
    brew_install "Z" "z"

    brew_install "Zsh Completion" "zsh-completion"

}

main