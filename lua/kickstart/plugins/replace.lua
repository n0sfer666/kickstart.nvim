return {
  {
    'nvim-pack/nvim-spectre',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('spectre').setup {
        default = {
          find = {
            cmd = 'rg',
            options = {},
          },
          replace = {
            cmd = 'sed',
          },
        },
        find_engine = {
          ['rg'] = {
            cmd = 'rg',
            args = {
              '--color=never',
              '--no-heading',
              '--with-filename',
              '--line-number',
              '--column',
            },
            options = {
              ['ignore-case'] = {
                value = '--ignore-case',
                icon = '[I]',
                desc = 'ignore case',
              },
            },
          },
        },
        replace_engine = {
          ['sed'] = {
            cmd = 'sed',
            options = {
              ['ignore-case'] = {
                value = '--ignore-case',
                icon = '[I]',
                desc = 'ignore case',
              },
            },
          },
        },
        mapping = {
          ['toggle_ignore_case'] = {
            map = 'ti',
            cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
            desc = 'toggle ignore case',
          },
          ['show_option_menu'] = {
            map = '<leader>o',
            cmd = "<cmd>lua require('spectre').show_options()<CR>",
            desc = 'show options',
          },
        },
      }
    end,
  },
}
