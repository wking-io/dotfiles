# DOTFILES

**Generated:** 2026-05-09T00:00:00Z
**Commit:** 871ce6f

macOS dev env via GNU Stow. Fish + Neovim + Git + pi.

## STRUCTURE

```
.dotfiles/
├── dot                 # CLI: init/update/doctor/stow/package (2500 lines bash)
├── home/.config/       # Stowed to ~/.config/
│   ├── fish/           # Shell (AGENTS.md)
│   ├── nvim/           # Editor (AGENTS.md)
│   ├── git/            # Conditional personal identity
│   ├── karabiner/      # Caps Lock → Esc/Ctrl, fn → Hyper
│   ├── starship.toml   # Prompt (minimal: directory + branch + ❯❯❯)
│   └── ripgrep/        # rg config
├── home/.agents/       # Shared agent skills (stowed to ~/.agents/)
│   └── skills/         # SKILL.md packages for pi and other agents
├── home/.pi/           # Pi agent workspace (AGENTS.md)
│   └── agent/extensions/ # TypeScript extensions
├── packages/
│   ├── bundle          # Base Brewfile (32 formulas, 13 casks)
│   └── bundle.work     # Work additions (formulas only)
└── docs/
```

## WHERE TO LOOK

| Task | Location |
|------|----------|
| Add package | `dot package add <name>` or edit `packages/bundle` |
| Shell alias/abbr | `home/.config/fish/conf.d/aliases.fish` |
| Shell function | `home/.config/fish/functions/` |
| Git alias | `home/.config/git/config` [alias] section |
| Neovim plugin | `home/.config/nvim/lua/wking/plugins/<name>.lua` |
| Neovim keymap | `home/.config/nvim/lua/wking/keymaps.lua` |
| Starship prompt | `home/.config/starship.toml` |
| Agent skill | `home/.agents/skills/<name>/SKILL.md` |
| Pi extension | `home/.pi/agent/extensions/<name>/` |
| Pi settings | `home/.pi/agent/settings.json` |
| Git identity | Work (wking@cloudflare.com) by default; personal via `home/.config/git/personal_config` for `~/Developer/personal/` |

## CONVENTIONS

- Stow layout: `home/` mirrors `~`, stow creates symlinks
- Fish: `conf.d/` auto-sourced, `functions/` lazy-loaded
- Neovim: 1 plugin per file in `lua/wking/plugins/`, returns lazy.nvim spec; `lazy-lock.json` is tracked
- Git abbrs: ~180 oh-my-zsh style via `__git.init.fish`
- Private helpers: prefix `__` (e.g., `__git.default_branch`)
- Pi extensions: TypeScript, npm workspaces under `home/.pi/`
- Agent skills: Markdown-first (`SKILL.md`) under `home/.agents/skills/`, stowed to `~/.agents/skills/`

## ANTI-PATTERNS

- Edit `~/.config/*` directly (changes lost on stow)
- Casks in `bundle.work` (use base bundle)
- Hardcode paths (use `$DOTFILES_DIR`, `$HOME`)
- Nested git repos in stowed dirs (creates symlink issues)
- node_modules in stowed dirs (pi extensions exception — gitignored)
- Skill copies under `home/.pi/agent/skills/` or `~/.pi/agent/skills/`
- Replacing `~/.agents/skills/<name>` stow symlinks with real directories

## IF YOU NOTICE SKILL LAYOUT DRIFT — FIX IT

Canonical skills live in `home/.agents/skills/<name>/` and stow to `~/.agents/skills/<name>` as a symlink. If you see any of these, fix them without being asked:

- A skill under `home/.pi/agent/skills/` or `~/.pi/agent/skills/`: move unique content into `home/.agents/skills/`, then delete the `.pi` copy/symlink.
- `~/.agents/skills/<name>` is a real directory instead of a symlink: copy it back into `home/.agents/skills/<name>/`, remove the live dir, restore the stow symlink.
- `skills` / `vpx skills add|update` wrote copies into `~/.agents` or `~/.pi`: fold the content into the repo copy, restore stow symlinks, do not leave a second tree.
- Do not restore skills the user deleted from `home/.agents/skills/`.

## COMMANDS

```bash
dot init              # Full setup (brew, stow, bun, vp, pi, ssh, fish)
dot update            # Pull + brew update/upgrade + restow + pi update
dot doctor            # Health check
dot stow              # Resymlink only
dot package add X     # Add + install package
dot benchmark-shell   # Fish startup perf
dot gen-ssh-key       # Generate ed25519 key by email domain
```

## KEY CONFIGS

| Tool | Entry | Notes |
|------|-------|-------|
| Fish | `config.fish` | Sources `conf.d/`, sets EDITOR/MANPAGER |
| Neovim | `init.lua` | `wking.*` modules + lazy.nvim bootstrap |
| Git | `config` | No signing, `pull.rebase`, conditional personal include, WARP CA include |
| Starship | `starship.toml` | Minimal: directory, git branch, ❯❯❯ (no language modules) |
| Pi | `settings.json` | Private gateway provider, ember-hollow theme (`home/.pi/agent/themes/ember-hollow.json`) |

## UNIQUE STYLES

- nvim: kickstart-based, leader `<Space>`, nvim-cmp, ember-hollow colorscheme
- git: `fomo` = fetch origin main + rebase; `lg` = graph log; `nuke` = discard all changes (keeps other stashes)
- Font: Paper Mono, with Symbols Nerd Font Mono as the fallback for icons (Rex via `dot`'s `__configure_rex`, Neovim GUI via `guifont` in `options.lua`; both font casks are in `packages/bundle`)
- Theme: Rex's built-in Ember Hollow everywhere. Rex sets it via `dot` (`Workspace.darkThemeID`); fish (`conf.d/ember_hollow_theme.fish`), Neovim (`colors/ember-hollow.lua` + `lua/wking/ember_hollow.lua`), OpenCode (`opencode/themes/ember-hollow.json`), pi, and starship copy its palette

## NOTES

- `dot update` handles WARP VPN brew API issues automatically
- Starship shows no language versions, so Vite+ node shims are never probed
- `secrets.fish` is gitignored — contains env tokens for work services
- `.pi/agent/*` mostly gitignored; extensions, `mcp.json` (cf-portal), and `private-gateway.json` explicitly un-ignored. Auth steps: `home/.pi/AGENTS.md` → NOTES
- jj was removed; repo now uses git only
