# fnm - Fast Node Manager
# Binary is in ~/.local/bin, node versions stored in ~/.local/share/fnm
if command -v fnm &> /dev/null
    set -gx FNM_DIR "$HOME/.local/share/fnm"
    fnm env --use-on-cd --shell fish | source
end
