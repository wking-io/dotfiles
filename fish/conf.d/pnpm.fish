# pnpm
# Binary is in ~/.local/bin (unified location)
# Global packages are in PNPM_HOME for pnpm to manage

switch (uname)
    case Darwin
        if test -d "$HOME/Library/pnpm"
            set -gx PNPM_HOME "$HOME/Library/pnpm"
        else
            set -gx PNPM_HOME "$HOME/.local/share/pnpm"
        end
    case '*'
        set -gx PNPM_HOME "$HOME/.local/share/pnpm"
end
