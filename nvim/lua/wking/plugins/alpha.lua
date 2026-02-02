--------------------------------------------------------------------------------
-- Alpha: A fast and fully programmable start screen greeter!
-------------------------------a-------------------------------------------------

return {
  'goolord/alpha-nvim',
  dependencies = {
    'echasnovski/mini.icons',
    'tjdevries/colorbuddy.nvim',
    'sainnhe/everforest',
  },
  lazy = false,
  keys = {
    { 'i', ':enew<CR>i', ft = 'alpha', silent = true },
    { 'a', ':enew<CR>a', ft = 'alpha', silent = true },
    { '<Esc>', ':bd<CR>', ft = 'alpha', silent = true },
    { 'q', ':bd<CR>', ft = 'alpha', silent = true },
    { '<C-c>', ':bd<CR>', ft = 'alpha', silent = true },
    { '<Leader>c', ':bd<CR>', ft = 'alpha', silent = true },
    { '<Leader>v', ':bd<CR>:vsplit<CR>', ft = 'alpha', silent = true },
    { ':', ':bd<CR>:', ft = 'alpha' },
  },
  config = function()
    local alpha = require 'alpha'
    local theme = require 'alpha.themes.dashboard'
    local configuration = vim.fn['everforest#get_configuration']()
    local palette = vim.fn['everforest#get_palette'](configuration.background, configuration.colors_override)

    vim.api.nvim_set_hl(0, 'AlphaPrimary', { fg = palette.fg[1] })
    vim.api.nvim_set_hl(0, 'AlphaSecondary', { fg = palette.bg5[1] })
    vim.api.nvim_set_hl(0, 'AlphaAccent1', { fg = '#F94001' })
    vim.api.nvim_set_hl(0, 'AlphaAccent2', { fg = '#F96209' })
    vim.api.nvim_set_hl(0, 'AlphaAccent3', { fg = '#F4730B' })
    vim.api.nvim_set_hl(0, 'AlphaAccent4', { fg = '#F68A06' })
    vim.api.nvim_set_hl(0, 'AlphaAccent5', { fg = '#ED9D0B' })
    vim.api.nvim_set_hl(0, 'AlphaAccent6', { fg = '#FFA80E' })

    -- Manually set this total height based on number of rendered lines configured!
    local total_height = 28

    local button_spacing = 1
    local version_spacing = 0

    local pad = function(height)
      return math.ceil((vim.fn.winheight(0) - height) / 2)
    end

    if pad(total_height) < 3 then
      total_height = total_height - 5
      button_spacing = 0
      version_spacing = 1
    end

    local crown = {
      [[   ██          ██          ██   ]],
      [[ ██████      ██████      ██████ ]],
      [[ ████████  ████  ████  ████████ ]],
      [[ ██  ▓███████      ███████▓  ██ ]],
      [[ ██████████████  ██████████████ ]],
      [[ ██  ▓█████████  █████████▓  ██ ]],
      [[ ██  ▓█████████  █████████▓  ██ ]],
      [[ ██  ▓█████████  █████████▓  ██ ]],
      [[ ██  ▓█████████  █████████▓  ██ ]],
      [[ ██  ▓█░░░░░░░░░░░░░░░░░░█▓  ██ ]],
      [[ ████░░                  ░░████ ]],
      [[ ██░░                      ░░██ ]],
      [[   ████                  ████   ]],
      [[       ██████████████████       ]],
    }

    local groups = {
      'AlphaAccent1',
      'AlphaAccent1',
      'AlphaAccent2',
      'AlphaAccent2',
      'AlphaAccent3',
      'AlphaAccent3',
      'AlphaAccent4',
      'AlphaAccent4',
      'AlphaAccent5',
      'AlphaAccent5',
      'AlphaAccent6',
      'AlphaAccent6',
      'AlphaAccent6',
      'AlphaAccent6',
    }

    local function createGradientCrown(lines)
      local result = {}
      for index, line in ipairs(lines) do
        table.insert(result, {
          type = 'text',
          val = line,
          opts = {
            position = 'center',
            hl = groups[index],
          },
        })
      end
      return result
    end

    local header = {
      type = 'group',
      val = createGradientCrown(crown),
      opts = {
        position = 'center',
      },
    }

    local buttons = {
      type = 'group',
      val = {
        theme.button('f', '  Find file', "<cmd>lua Snacks.picker.files()<cr>"),
        theme.button('r', '  Recently used files', '<cmd>lua Snacks.picker.recent()<cr>'),
        theme.button('t', '󱄽  Find text', '<cmd>lua Snacks.picker.grep()<cr>'),
        theme.button('c', '  Configuration', ':e ~/.config/nvim/init.lua <CR>'),
        theme.button('q', '󰅜  Quit Neovim', ':qa<CR>'),
      },
      opts = {
        spacing = button_spacing,
      },
    }

    local v = vim.version()

    local version = {
      type = 'text',
      val = 'NVIM v' .. v.major .. '.' .. v.minor .. '.' .. v.patch,
      opts = {
        position = 'center',
        hl = 'AlphaSecondary',
      },
    }

    theme.config = {
      layout = {
        { type = 'padding', val = pad(total_height) },
        { type = 'padding', val = 1 },
        header,
        { type = 'padding', val = 3 },
        buttons,
        { type = 'padding', val = version_spacing },
        version,
      },
    }

    alpha.setup(theme.config)
  end,
}
