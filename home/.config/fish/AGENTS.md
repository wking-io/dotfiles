# FISH SHELL CONFIG

**Generated:** 2026-05-09T00:00:00Z
**Commit:** 871ce6f

Layered: `config.fish` -> `conf.d/*.fish` (auto) -> `functions/*.fish` (lazy)

## STRUCTURE

```
fish/
├── config.fish         # Core: greeting, LANG, EDITOR/VISUAL/SUDO_EDITOR, MANPAGER, vi bindings, vim/vi/v abbrs
├── conf.d/             # Auto-sourced config fragments (16 files)
│   ├── aliases.fish    # Shell aliases (c, code, gs, gch, oc, p/pn, wr, npx/bunx→vpx)
│   ├── paths.fish      # PATH: .local/bin, .cargo/bin, .dotfiles, .opencode/bin
│   ├── git.fish        # Git abbreviations init
│   ├── brew.fish       # Homebrew setup
│   ├── vite-plus.fish  # Sources Vite+ env
│   ├── starship.fish   # Starship prompt init
│   ├── secrets.fish    # Env tokens (GITIGNORED)
│   └── ...             # Tool-specific (bun, fzf, pnpm, zoxide, rustup, orbstack, direnv)
├── functions/          # Lazy-loaded functions (31 files)
│   ├── __git.*.fish    # Internal git helpers (5 files)
│   ├── gwip.fish       # WIP commit
│   └── ...             # Utilities (uuid, ulid, timer, notify, nato, rn)
└── completions/        # Command completions (dot, bun, wrangler, kubectl, vp)
```

## WHERE TO LOOK

| Task | Location |
|------|----------|
| Add alias | `conf.d/aliases.fish` |
| Add PATH | `conf.d/paths.fish` |
| Add function | `functions/<name>.fish` (1 function per file) |
| Git abbr | `functions/__git.init.fish` (180+ abbrs) |
| Tool setup | `conf.d/<tool>.fish` |
| Completions | `completions/<cmd>.fish` |
| Env secrets | `conf.d/secrets.fish` (gitignored) |

## CONVENTIONS

- Functions use `-d "description"` flag (mandatory)
- Private helpers prefix `__` (e.g., `__git.default_branch`)
- Namespace pattern: `__<namespace>.<function>` (dot-separated)
- Fallback chains for cross-platform compat (uuidgen -> python3 -> node)
- Fisher for plugin management (`fish_plugins`)
- Use `fish_add_path` not manual `set PATH`
- Use `set -gx` for global exports

## ANTI-PATTERNS

- Heavy work in `config.fish` (use `conf.d/` fragments)
- Blocking commands at startup (defer to function)
- Global vars without `set -gx`
- Using `~` in scripts (use `$HOME`)

## KEY ALIASES

| Alias | Expands To |
|-------|------------|
| `c` | clear |
| `code` | nvim |
| `vim`/`vi`/`v` | abbreviations for nvim (`config.fish`) |
| `gs` / `gch` | git status / git checkout |
| `oc` | opencode |
| `p` | pnpm |
| `npx`/`bunx` | vpx (Vite+) |
| `pn` | pnpm |
| `wr` | wrangler |
| `pbc`/`pbp` | pbcopy/pbpaste |
| `scratch` | nvim with nofile buftype |

## GIT ABBREVIATIONS

~180 oh-my-zsh style abbrs loaded via `__git.init`:
- Basic: `g`, `gst`, `gd`, `ga`, `gc`, `gp`, `gl`
- Branch: `gb`, `gco`, `gcb`, `gbd`, `gbD`, `gcom` (checkout default)
- Rebase: `grb`, `grbi`, `grbm`, `grbom` (fetch origin main + rebase)
- Amend: `gc!`, `gcan!`
- Push: `gp!` (force-with-lease), `gpu` (set-upstream)
- Stash: `gsta`, `gstp`
- Worktree: `gwt*`

## CUSTOM FUNCTIONS

| Function | Purpose |
|----------|---------|
| `gwip`/`gunwip` | Create/undo WIP commit |
| `gbda` | Delete merged branches (incl. squash-merged); lists them and asks first |
| `git_rebase_stack`/`gstk` | Rebase PR stack, auto-detects via gh |
| `gtest <cmd>` | Test command against staged changes only |
| `gbage` | List branches by age |
| `grename <old> <new>` | Rename branch locally + remote |
| `fvim [query]` | fzf → nvim |
| `uuid`/`ulid` | Generate IDs |
| `timer <duration>` | Countdown with notification (5s, 10m, 1h) |
| `notify <msg>` | Desktop notification |
| `tempd` | cd into new temp directory |
| `trash <file>` | Safe delete to ~/.Trash |
| `httpstatus <code>` | HTTP status lookup (supports wildcards) |
| `nato <text>` | Convert text to NATO phonetic alphabet |
| `rn` | Right now — current time + calendar |
| `mcd <dir>` | mkdir -p + cd |
| `freshignore` | Re-apply .gitignore (rm --cached, re-add, commit) |
| `h2` / `summit` / `cbsudo` | Project helpers (Shopify Hydrogen, summit dev stack, Crunchy Bridge sudo) |

## NOTES

- `secrets.fish` + `vault-funcs.fish` are gitignored — contain sensitive tokens
- Vi key bindings (`fish_vi_key_bindings`) are on in interactive shells
- `everforest_theme.fish` sets shell colors to match the global Everforest theme
- fzf key bindings (Ctrl-T files, Ctrl-R history, Alt-C cd) come from `conf.d/fzf.fish`
