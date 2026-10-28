# NEOVIM

kickstart.nvim-derived config, managed by lazy.nvim. Stowed to `~/.config/nvim`.

## STRUCTURE

```
nvim/
├── init.lua                 # Requires wking.{disable,globals,options,keymaps}, bootstraps lazy.nvim, loads `wking.plugins`
├── lazy-lock.json           # Pinned plugin versions (tracked; update via :Lazy update, then commit)
├── .stylua.toml             # 2 spaces, single quotes, no call parens, 160 cols
├── after/plugin/theme.lua   # Yank highlight, 121st-column highlight after alpha closes
└── lua/wking/
    ├── disable.lua          # Disables builtin plugins (netrw, gzip, zip, tar, ...)
    ├── globals.lua          # P() inspect helper, R() plenary reload helper
    ├── options.lua          # Editor options (nerd font on, relative numbers, 2-space indent)
    ├── keymaps.lua          # General keymaps (leader = <Space>)
    ├── health.lua           # :checkhealth wking
    └── plugins/             # One lazy.nvim spec per file, auto-imported
```

## WHERE TO LOOK

| Task | Location |
|------|----------|
| Add plugin | New file in `lua/wking/plugins/<name>.lua` returning a lazy spec |
| Keymap (general) | `lua/wking/keymaps.lua` |
| Keymap (plugin) | That plugin's spec (`keys = {...}` or inside `config`) |
| Option | `lua/wking/options.lua` |
| LSP server | `lua/wking/plugins/lsp.lua` `servers` table (installed by mason-tool-installer) |
| TypeScript | `lua/wking/plugins/typescript.lua` (typescript-tools, `@effect/language-service`) |
| Formatter | `lua/wking/plugins/conform.lua` (JS/TS: oxfmt → biome → prettierd/prettier by project config) |
| Linter | `lua/wking/plugins/lint.lua` (nvim-lint), `null-ls.lua` (phpstan via none-ls) |
| Theme | `lua/wking/plugins/theme.lua` (everforest, hard background) |

## KEY PLUGINS

- Completion: nvim-cmp + LuaSnip (+ tailwindcss-colorizer-cmp)
- Navigation: telescope (fzf-native, ui-select), neo-tree (netrw disabled)
- LSP: nvim-lspconfig + mason / mason-lspconfig / mason-tool-installer, fidget, lazydev
- UI: alpha (start screen), mini.nvim, which-key, snacks, trouble, todo-comments, indent-blankline, gitsigns
- Debug: nvim-dap + dap-ui (+ dap-go)
- AI: opencode.nvim (`<leader>oo/oa/os`); pi runs in the terminal
- PHP: intelephense, phpstan

## CONVENTIONS

- Lua style per `.stylua.toml`: `require 'x'`, single quotes, 2-space indent
- `lazy.setup('wking.plugins', ...)` imports every file in `lua/wking/plugins/`
- `dev.path = ~/Developer/packages` for local plugin development (`dev = true` in a spec)
- Commit `lazy-lock.json` after plugin updates
