set -x LANG en_US.UTF-8

fish_vi_key_bindings

set -gx EDITOR (which nvim)
set -gx VISUAL $EDITOR
set -gx SUDO_EDITOR $EDITOR

# EDITOR
abbr vim nvim
abbr vi nvim
abbr v nvim

