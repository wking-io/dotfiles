# Homebrew configuration (macOS and Linux)
# Detect and configure Homebrew if installed

# Check for Homebrew in common locations
if test -x /opt/homebrew/bin/brew
    # macOS Apple Silicon
    set -gx HOMEBREW_PREFIX "/opt/homebrew"
    set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar"
    set -gx HOMEBREW_REPOSITORY "/opt/homebrew"
else if test -x /usr/local/bin/brew
    # macOS Intel
    set -gx HOMEBREW_PREFIX "/usr/local"
    set -gx HOMEBREW_CELLAR "/usr/local/Cellar"
    set -gx HOMEBREW_REPOSITORY "/usr/local/Homebrew"
else if test -x /home/linuxbrew/.linuxbrew/bin/brew
    # Linux (Linuxbrew)
    set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
    set -gx HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar"
    set -gx HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew"
else if test -x "$HOME/.linuxbrew/bin/brew"
    # Linux (user install)
    set -gx HOMEBREW_PREFIX "$HOME/.linuxbrew"
    set -gx HOMEBREW_CELLAR "$HOME/.linuxbrew/Cellar"
    set -gx HOMEBREW_REPOSITORY "$HOME/.linuxbrew/Homebrew"
end

# Only configure paths if Homebrew was found
if set -q HOMEBREW_PREFIX
    fish_add_path --global --move --path "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"

    if test -n "$MANPATH[1]"
        set -gx MANPATH '' $MANPATH
    end

    if not contains "$HOMEBREW_PREFIX/share/info" $INFOPATH
        set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH
    end
end
