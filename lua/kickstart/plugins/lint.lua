return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      local lspconfig = require 'lspconfig'

      local on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader>cn', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'LSP Code Actions' }))
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to Definition' }))
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover Docs' }))
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename Symbol' }))
      end

      lspconfig.eslint.setup {
        on_attach = on_attach,
        settings = {
          codeAction = {
            disableRuleComment = { enable = true },
            showDocumentation = { enable = true },
          },
          codeActionOnSave = { enable = true, mode = 'all' },
          format = { enable = true },
        },
      }

      lspconfig.ts_ls.setup {
        on_attach = on_attach,
      }

      lspconfig.jsonls.setup {
        on_attach = on_attach,
        settings = {
          json = {
            validate = { enable = true },
          },
        },
      }
    end,
  },
}
