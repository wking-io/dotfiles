-- Ember Hollow colorscheme lives in colors/ember-hollow.lua; it reuses everforest's highlight groups.
return {
  'sainnhe/everforest',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'ember-hollow'
  end,
}
