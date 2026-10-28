# Disable greeting
set fish_greeting

set -x LANG en_US.UTF-8

set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

# Use neovim to read manpages
set -gx MANPAGER 'nvim +Man!'

if status is-interactive
    fish_vi_key_bindings

    # EDITOR
    abbr vim nvim
    abbr vi nvim
    abbr v nvim
end
