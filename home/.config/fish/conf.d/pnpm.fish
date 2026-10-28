# pnpm
# Global packages are in PNPM_HOME for pnpm to manage
if test -d "$HOME/Library/pnpm"
    set -gx PNPM_HOME "$HOME/Library/pnpm"
else
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"
end
