return {
  url = 'https://git.sr.ht/~p00f/alabaster.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'alabaster'

    -- Configure alabaster options
    vim.g.alabaster_dim_comments = true
    vim.g.alabaster_floatborder = true

    -- Enable transparency
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

    -- Custom highlights
    vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#8feb00' })
    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#ffbf00' })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#ef6bce' })
    vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', { fg = '#a4a4a4' })
  end,
}
