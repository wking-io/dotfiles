# Homebrew configuration (Apple Silicon or Intel macOS)
if test -x /opt/homebrew/bin/brew
    set -gx HOMEBREW_PREFIX "/opt/homebrew"
    set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar"
    set -gx HOMEBREW_REPOSITORY "/opt/homebrew"
else if test -x /usr/local/bin/brew
    set -gx HOMEBREW_PREFIX "/usr/local"
    set -gx HOMEBREW_CELLAR "/usr/local/Cellar"
    set -gx HOMEBREW_REPOSITORY "/usr/local/Homebrew"
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
