# Unified PATH configuration
# All user-installed binaries go to ~/.local/bin
# Tool-specific data (node versions, pnpm packages) stays in ~/.local/share

# Primary user bin directory - all tools install here
if test -d "$HOME/.local/bin"
    fish_add_path --global --prepend "$HOME/.local/bin"
end

# Cargo (Rust) - keeps its own structure
if test -d "$HOME/.cargo/bin"
    fish_add_path --global "$HOME/.cargo/bin"
end
