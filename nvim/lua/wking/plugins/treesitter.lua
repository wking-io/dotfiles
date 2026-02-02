return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  config = function()
    local parsers = { "bash", "c", "diff", "gleam", "html", "javascript", "lua", "luadoc", "markdown", "markdown_inline", "query", "tsx", "typescript", "vim", "vimdoc" }

    require("nvim-treesitter").setup()

    -- Install parsers
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      once = true,
      callback = function()
        require("nvim-treesitter").install(parsers)
      end,
    })

    -- Enable treesitter highlighting
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })

    -- Enable treesitter-based indentation (experimental)
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- Enable treesitter-based folding
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldlevel = 99
      end,
    })
  end,
}
