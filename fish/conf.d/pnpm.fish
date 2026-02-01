# pnpm
# Use XDG-compliant path, with fallback for macOS legacy location

switch (uname)
    case Darwin
        # macOS: check legacy location first, then XDG
        if test -d "$HOME/Library/pnpm"
            set -gx PNPM_HOME "$HOME/Library/pnpm"
        else
            set -gx PNPM_HOME "$HOME/.local/share/pnpm"
        end
    case '*'
        # Linux and others: use XDG-compliant path
        if set -q XDG_DATA_HOME
            set -gx PNPM_HOME "$XDG_DATA_HOME/pnpm"
        else
            set -gx PNPM_HOME "$HOME/.local/share/pnpm"
        end
end

if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
