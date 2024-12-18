--------------------------------------------------------------------------------
-- General Keymaps (that aren't related other plugins or config modules)
--------------------------------------------------------------------------------

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Save file and quite with leader
vim.keymap.set('n', '<leader>w', ':w<CR>', { silent = true, desc = 'Save' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = '[Q]uit' })

-- Buffer deletes

vim.keymap.set('n', '<leader>bd', function()
  vim.api.nvim_buf_delete(0, {})
end, { desc = 'Delete current buffer' })

vim.keymap.set('n', '<leader>bc', function()
  local bufs = vim.api.nvim_list_bufs()
  for _, i in ipairs(bufs) do
    vim.api.nvim_buf_delete(i, {})
  end
end, { desc = 'Delete all buffers' })

vim.keymap.set('n', '<leader>bc', function()
  local bufs = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, i in ipairs(bufs) do
    if i ~= current_buf then
      vim.api.nvim_buf_delete(i, {})
    end
  end
end, { desc = 'Delete all buffers except current' })
