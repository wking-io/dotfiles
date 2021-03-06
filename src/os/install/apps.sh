#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Apps\n\n"


# daily
brew_install "Dropbox" "dropbox" "caskroom/cask" "cask"
brew_install "Slack" "slack" "caskroom/cask" "cask"
brew_install "Karabiner-Elements" "karabiner-elements" "caskroom/cask" "cask"
brew_install "BetterTouchTool" "bettertouchtool" "caskroom/cask" "cask"
brew_install "Clean My Mac" "cleanmymac" "caskroom/cask" "cask"
brew_install "Clipy" "clipy" "caskroom/cask" "cask"
brew_install "Notion" "notion" "caskroom/cask" "cask"

# dev
brew_install "Hyper" "hyper" "caskroom/cask" "cask"
brew_install "VS Code" "visual-studio-code" "caskroom/cask" "cask"
brew_install "Transmit" "transmit" "caskroom/cask" "cask"
brew_install "Sequel Pro" "sequel-pro" "caskroom/cask" "cask"


# design
brew_install "Figma" "figma" "caskroom/cask" "cask"

print_in_purple "\n Don't forget to get Magnet, Local By Flywheel, and VirtualBox\n"
