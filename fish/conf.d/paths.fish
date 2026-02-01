# Additional PATH entries for common installation locations
# This handles tools installed via manual scripts

# Local bin directory (common for manually installed tools)
if test -d "$HOME/.local/bin"
    fish_add_path --global "$HOME/.local/bin"
end

# Cargo (Rust)
if test -d "$HOME/.cargo/bin"
    fish_add_path --global "$HOME/.cargo/bin"
end

# Go binaries
if test -d "$HOME/go/bin"
    fish_add_path --global "$HOME/go/bin"
end

# fnm (Fast Node Manager) - added by install script
if test -d "$HOME/.local/share/fnm"
    fish_add_path --global "$HOME/.local/share/fnm"
end
