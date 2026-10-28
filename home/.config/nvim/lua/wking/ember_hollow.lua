--------------------------------------------------------------------------------
-- Ember Hollow palette
--------------------------------------------------------------------------------
-- Colors copied from Rex's built-in "Ember Hollow" theme
-- (/Applications/Rex Beta.app/.../SuperUI_SuperDesignTokens.bundle/.../themes.json).
-- Shared by colors/ember-hollow.lua and the alpha start screen.

local M = {}

-- Rex semantic + terminal ANSI colors, as hex strings.
M.rex = {
  canvas = '#171210',
  sidebar = '#1e1917',
  terminal_background = '#1b1614',
  surface_raised = '#272220',
  control_on_overlay = '#2b2623',
  stroke_subtle = '#39322f',
  stroke = '#4e4641',
  scrollbar_hover = '#5d534e',
  content = '#e0cfc4',
  content_secondary = '#94877f',
  content_tertiary = '#756a64',
  accent = '#f0955c',
  accent_container = '#34241c',
  danger = '#e06c4f',
  danger_container = '#331f1a',
  success = '#a3b06a',
  success_container = '#2a271d',
  warning = '#e8a75a',
  warning_container = '#33261c',
  info = '#8e9fb3',
  info_container = '#282526',
  terminal_selection = '#47302a',
  terminal_selection_foreground = '#f3e8e0',
  ansi = {
    [0] = '#241b17',
    '#e06c4f',
    '#a3b06a',
    '#e8a75a',
    '#8e9fb3',
    '#c98a8e',
    '#8fb0a2',
    '#c3b3a8',
    '#6b5a50',
    '#f08767',
    '#bcc985',
    '#f5bf77',
    '#a8b9cc',
    '#dda4a7',
    '#a9c9ba',
    '#f3e8e0',
  },
}

local rex = M.rex

-- Palette in sainnhe/everforest's `g:everforest_colors_override` format: { gui hex, cterm 256 index }.
-- colors/ember-hollow.lua feeds this into everforest so every plugin highlight group it ships is recolored.
M.everforest_colors_override = {
  bg_dim = { rex.canvas, '233' },
  bg0 = { rex.terminal_background, '234' },
  bg1 = { rex.surface_raised, '235' },
  bg2 = { rex.control_on_overlay, '235' },
  bg3 = { rex.stroke_subtle, '236' },
  bg4 = { rex.stroke, '238' },
  bg5 = { rex.scrollbar_hover, '239' },
  bg_visual = { rex.terminal_selection, '52' },
  bg_red = { rex.danger_container, '52' },
  bg_yellow = { rex.warning_container, '58' },
  bg_green = { rex.success_container, '22' },
  bg_blue = { rex.info_container, '17' },
  bg_purple = { '#33252a', '53' },
  fg = { rex.content, '224' },
  red = { rex.danger, '167' },
  orange = { rex.accent, '209' },
  yellow = { rex.warning, '179' },
  green = { rex.success, '143' },
  aqua = { rex.ansi[6], '109' },
  blue = { rex.info, '103' },
  purple = { rex.ansi[5], '174' },
  grey0 = { rex.content_tertiary, '243' },
  grey1 = { rex.content_secondary, '245' },
  grey2 = { rex.ansi[7], '250' },
  statusline1 = { rex.success, '143' },
  statusline2 = { rex.content, '224' },
  statusline3 = { rex.danger, '167' },
}

return M
