--------------------------------------------------------------------------------
-- Ember Hollow colorscheme (matches Rex's built-in "Ember Hollow" theme)
--------------------------------------------------------------------------------
-- Reuses sainnhe/everforest's highlight definitions (treesitter, LSP, and plugin groups)
-- with the palette swapped for Ember Hollow colors from lua/wking/ember_hollow.lua.

local ember_hollow = require 'wking.ember_hollow'

vim.o.background = 'dark'
vim.g.everforest_background = 'hard'
vim.g.everforest_enable_italic = true
vim.g.everforest_colors_override = ember_hollow.everforest_colors_override

-- Source the file instead of `:colorscheme everforest`: Neovim ignores nested `:colorscheme` calls.
vim.cmd.runtime 'colors/everforest.vim'
vim.g.colors_name = 'ember-hollow'

-- Built-in :terminal uses the same ANSI colors as Rex.
for index = 0, 15 do
  vim.g['terminal_color_' .. index] = ember_hollow.rex.ansi[index]
end
