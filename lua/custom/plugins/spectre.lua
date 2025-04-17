return {
  {
    'nvim-pack/nvim-spectre',
    config = function()
      require('spectre').setup()
      vim.keymap.set('n', '<leader>rr', function()
        require('spectre').open()
      end, { desc = 'Replace in files (Spectre)' })
    end,
  },
}
