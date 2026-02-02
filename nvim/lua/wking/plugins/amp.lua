return {
  "sourcegraph/amp.nvim",
  branch = "main",
  lazy = false,
  opts = { auto_start = true, log_level = "info" },
  config = function(_, opts)
    require("amp").setup(opts)

    vim.api.nvim_create_user_command("AmpSend", function(cmd_opts)
      local message = cmd_opts.args
      if message == "" then
        print("Please provide a message to send")
        return
      end
      require("amp.message").send_message(message)
    end, {
      nargs = "*",
      desc = "Send a message to Amp",
    })

    vim.api.nvim_create_user_command("AmpSendBuffer", function()
      local buf = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local content = table.concat(lines, "\n")
      require("amp.message").send_message(content)
    end, {
      nargs = "?",
      desc = "Send current buffer contents to Amp",
    })

    vim.api.nvim_create_user_command("AmpPromptSelection", function(cmd_opts)
      local lines = vim.api.nvim_buf_get_lines(0, cmd_opts.line1 - 1, cmd_opts.line2, false)
      local text = table.concat(lines, "\n")
      require("amp.message").send_to_prompt(text)
    end, {
      range = true,
      desc = "Add selected text to Amp prompt",
    })

    vim.api.nvim_create_user_command("AmpPromptRef", function(cmd_opts)
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname == "" then
        print("Current buffer has no filename")
        return
      end
      local relative_path = vim.fn.fnamemodify(bufname, ":.")
      local ref = "@" .. relative_path
      if cmd_opts.line1 ~= cmd_opts.line2 then
        ref = ref .. "#L" .. cmd_opts.line1 .. "-" .. cmd_opts.line2
      elseif cmd_opts.line1 > 1 then
        ref = ref .. "#L" .. cmd_opts.line1
      end
      require("amp.message").send_to_prompt(ref)
    end, {
      range = true,
      desc = "Add file reference (with selection) to Amp prompt",
    })
  end,
}
