return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- Base linters (non-JS/TS)
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
      }

      -- Utility function to check for ESLint config
      local function eslint_config_exists()
        return vim.fn.filereadable '.eslintrc.js' == 1
          or vim.fn.filereadable '.eslintrc.json' == 1
          or vim.fn.filereadable '.eslintrc.yml' == 1
          or vim.fn.filereadable '.eslintrc' == 1
          or vim.fn.filereadable 'eslint.config.js' == 1
          or vim.fn.filereadable 'eslint.config.mjs' == 1
          or vim.fn.filereadable 'eslint.config.ts' == 1
      end

      -- Utility function to check for oxlint config
      local function oxlint_config_exists()
        return vim.fn.filereadable '.oxlintrc.json' == 1
      end

      -- Utility function to check for Biome config (legacy)
      local function biome_config_exists()
        return vim.fn.filereadable 'biome.json' == 1
          or vim.fn.filereadable 'biome.jsonc' == 1
      end

      -- JS/TS filetypes that can use either eslint or biome
      local js_filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          local ft = vim.bo.filetype

          -- For JS/TS filetypes, choose linter based on project config
          if vim.tbl_contains(js_filetypes, ft) then
            if oxlint_config_exists() then
              lint.try_lint 'oxlint'
            elseif biome_config_exists() then
              lint.try_lint 'biomejs'
            elseif eslint_config_exists() then
              lint.try_lint 'eslint_d'
            end
          -- For other filetypes, run configured linters if buffer is modifiable
          elseif vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
