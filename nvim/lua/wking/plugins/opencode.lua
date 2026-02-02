return {
  "nickjvandyke/opencode.nvim",
  dependencies = { "folke/snacks.nvim" },
  lazy = false,
  config = function()
    vim.g.opencode_opts = {}
    vim.o.autoread = true
  end,
  keys = {
    { "<leader>oo", function() require("opencode").toggle() end, desc = "Toggle opencode" },
    { "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, mode = { "n", "x" }, desc = "Ask opencode" },
    { "<leader>os", function() require("opencode").select() end, desc = "Select opencode prompt" },
  },
}
