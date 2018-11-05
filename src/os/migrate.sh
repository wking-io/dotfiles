#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • Update content\n\n"

    # make folders
    mkdir -p ~/migration/home
    mkdir -p ~/migration/Library/
    mkdir -p ~/migration/rootLibrary/Preferences/SystemConfiguration/

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # move into migrate directory

    cd ~/migration

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # backup some dotfiles likely not under source control

    cp -Rp
        ~/.gitconfig.local
        ~/.ssh \
        ~/.z   \
            ~/migration/home

    cp -Rp ~/Documents ~/migration
    cp -Rp /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist ~/migration/rootLibrary/Preferences/SystemConfiguration/ # wifi
    cp -Rp ~/Library/Fonts ~/migration/Library/ # my fonts

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # move from ~/migration => usb/migration-{mm/dd/yyyy}

    # mv ~/migration $1
    echo $1
}

echo $0
main $0
