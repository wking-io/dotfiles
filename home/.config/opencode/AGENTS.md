# Machine context

## Dotfiles

Dotfiles live in `~/.dotfiles`, a git repo managed with GNU Stow: `home/` mirrors `~`, and files under `~/.config/*`, `~/.agents`, and `~/.pi` are symlinks into it. Edit the source under `~/.dotfiles/home/`, then run `dot stow` to link any new file. Read `~/.dotfiles/AGENTS.md` before editing; it maps where each config lives.

The login shell is fish. Shell aliases go in `~/.dotfiles/home/.config/fish/conf.d/aliases.fish`, functions in `~/.dotfiles/home/.config/fish/functions/`.
