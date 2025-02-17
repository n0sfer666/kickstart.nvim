local colorscheme = 'tokyonight'

if colorscheme == 'tokyonight' then
  return {
    'folke/tokyonight.nvim',
    lazy = true,
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        sidebars = 'transparent',
        floats = 'transparent',
      },
      -- TODO: some todo
      --- You can override specific color groups to use other groups or a hex color
      --- function will be called with a ColorScheme table
      ---@param colors ColorScheme
      on_colors = function(colors)
        colors.comment = '#00a38d'
        colors.todo = '#00bd4d'
      end,

      --- You can override specific highlights to use other groups or a hex color
      --- function will be called with a Highlights and ColorScheme table
      ---@param highlights Highlights
      ---@param colors ColorScheme
      on_highlights = function(highlights, colors) end,
    },
    config = function(_, opts)
      local tokyonight = require 'tokyonight'
      tokyonight.setup(opts)
      tokyonight.load()
    end,
    init = function()
      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-storm'

      -- You can configure highlights by doing something like:
      vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#8feb00' })
      vim.api.nvim_set_hl(0, 'LineNr', { fg = '#ffbf00' })
      vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#ef6bce' })
      vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', { fg = '#a4a4a4' })
    end,
  }
end
