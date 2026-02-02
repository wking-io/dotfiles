#!/usr/bin/env bash
# Linux-specific installations for packages not in apt
# Run after apt packages are installed
#
# All user binaries install to ~/.local/bin for a unified PATH

set -e

echo "Installing Linux-specific packages..."

# Unified bin directory - all tools install here
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"
export PATH="$LOCAL_BIN:$PATH"

# Ensure unzip is installed (needed for fnm)
if ! command -v unzip &> /dev/null; then
    echo "Installing unzip (required for fnm)..."
    sudo apt install -y unzip
fi

# GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "Installing GitHub CLI..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh -y
fi

# Starship prompt
if ! command -v starship &> /dev/null; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$LOCAL_BIN"
fi

# fnm (Fast Node Manager)
if [ ! -f "$LOCAL_BIN/fnm" ]; then
    echo "Installing fnm..."
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$LOCAL_BIN" --skip-shell
fi

# zoxide
if [ ! -f "$LOCAL_BIN/zoxide" ]; then
    echo "Installing zoxide..."
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh -s -- --bin-dir "$LOCAL_BIN"
fi

# pnpm - install binary to ~/.local/bin, global packages to ~/.local/share/pnpm
if [ ! -f "$LOCAL_BIN/pnpm" ]; then
    echo "Installing pnpm..."
    export PNPM_HOME="$HOME/.local/share/pnpm"
    mkdir -p "$PNPM_HOME"
    curl -fsSL https://get.pnpm.io/install.sh | ENV="$HOME/.bashrc" SHELL="$(which bash)" bash -
    # Copy actual pnpm binary to unified location (installer creates a wrapper script)
    PNPM_EXE=$(find "$PNPM_HOME" -name "pnpm" -type f 2>/dev/null | head -1)
    if [ -n "$PNPM_EXE" ] && [ -f "$PNPM_EXE" ]; then
        cp "$PNPM_EXE" "$LOCAL_BIN/pnpm"
        chmod +x "$LOCAL_BIN/pnpm"
    fi
fi

# sesh (tmux session manager)
if [ ! -f "$LOCAL_BIN/sesh" ]; then
    echo "Installing sesh..."
    export GOBIN="$LOCAL_BIN"
    if command -v go &> /dev/null; then
        go install github.com/joshmedeski/sesh@latest
    else
        echo "Warning: Go not installed, skipping sesh. Install golang-go via apt first."
    fi
fi

# Ghostty (if available for Linux)
if ! command -v ghostty &> /dev/null; then
    echo "Note: Ghostty installation on Linux varies. Check https://ghostty.org for instructions."
fi

# Set fish as default shell
if command -v fish &> /dev/null; then
    FISH_PATH=$(which fish)
    CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
    if [ "$CURRENT_SHELL" != "$FISH_PATH" ]; then
        echo "Setting fish as default shell..."
        chsh -s "$FISH_PATH"
    fi
fi

echo ""
echo "Linux installation complete!"
echo ""
echo "All binaries installed to: $LOCAL_BIN"
echo ""
echo "Manual steps you may need:"
echo "  1. Install Nerd Fonts: https://www.nerdfonts.com/"
echo "  2. Install Ghostty from source or package if available"
