if true then
  return {}
else
  -- temporary disabled
  return {
    {
      'nvim-pack/nvim-spectre',
      config = function()
        require('spectre').setup {
          replace_engine = {
            ['sed'] = {
              cmd = 'sed',
              args = {
                '-i',
                '',
                '-E',
              },
            },
          },
        }
        vim.keymap.set('n', '<leader>rr', function()
          require('spectre').open()
        end, { desc = 'Replace in files (Spectre)' })
      end,
    },
  }
end
