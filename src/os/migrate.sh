#!/bin/bash

. "$HOME/.dotfiles/src/os/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
make_folders() {

    # make folders
    mkdir -p ~/migration/home
    mkdir -p ~/migration/Library/
    mkdir -p ~/migration/rootLibrary/Preferences/SystemConfiguration/
    mkdir -p $1

}

backup() {

    rsync --archive ~/.ssh ~/migration/home
    rsync --archive ~/.z ~/migration/home
    rsync --archive ~/.gitconfig.local ~/migration/home
    rsync --archive ~/sites ~/migration/home --exclude node_modules --exclude .DS_Store

    rsync --archive /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist ~/migration/rootLibrary/Preferences/SystemConfiguration/ # wifi
    rsync --archive ~/Library/Fonts ~/migration/Library/ # my fonts

}

main() {

    print_in_purple "\n • Migrate\n\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # make folders
    execute "make_folders $1" "Making migration folder in home directory"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # backup files

    execute "backup" "Backing up files"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # move from ~/migration => usb/migration-{mm-dd-yyyy}
    execute "mv ~/migration $1" "Moving local migration to External HDD"
}

main $1
