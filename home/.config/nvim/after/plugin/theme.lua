--------------------------------------------------------------------------------
-- Other Cosmetic Tweaks
--------------------------------------------------------------------------------

-- Highlight 121st character on lines that exceed 120, but only after alpha start screen is closed!
vim.cmd [[
  autocmd User AlphaClosed lua vim.fn.matchadd('ColorColumn', '\\%121v')
]]

-- Highlight briefly on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_on_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank {
      higroup = 'IncSearch',
      timeout = 150,
      on_macro = true,
    }
  end,
})
