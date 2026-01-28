-- Utility function to check for Biome config
local function biome_config_exists()
  return vim.fn.filereadable 'biome.json' == 1 or vim.fn.filereadable 'biome.jsonc' == 1
end

return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      local lsp_format_opt
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = 'never'
      else
        lsp_format_opt = 'fallback'
      end
      return {
        timeout_ms = 5000,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- JS/TS uses dynamic formatter selection below
      javascript = function()
        if biome_config_exists() then
          return { 'biome' }
        end
        return { 'prettierd', 'prettier', stop_after_first = true }
      end,
      typescript = function()
        if biome_config_exists() then
          return { 'biome' }
        end
        return { 'prettierd', 'prettier', stop_after_first = true }
      end,
      javascriptreact = function()
        if biome_config_exists() then
          return { 'biome' }
        end
        return { 'prettierd', 'prettier', stop_after_first = true }
      end,
      typescriptreact = function()
        if biome_config_exists() then
          return { 'biome' }
        end
        return { 'prettierd', 'prettier', stop_after_first = true }
      end,

      html = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      scss = { 'prettierd', 'prettier', stop_after_first = true },
      twig = { 'prettierd', 'prettier', stop_after_first = true },
    },
  },
}
