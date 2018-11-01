#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   VSCode\n\n"

brew_install "VS Code" "visual-studio-code" "caskroom/cask" "cask"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Check if `VS Code` was installed and command `code` is available.

if ! cmd_exists "code"; then
    print_error "VS Code was not installed correctly"
else
    code --install-extension shan.code-settings-sync --force
fi
