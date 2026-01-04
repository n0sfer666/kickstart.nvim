return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      local on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader>cn', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'LSP Code Actions' }))
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to Definition' }))
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover Docs' }))
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename Symbol' }))
      end

      vim.lsp.config.eslint = {
        cmd = { 'vscode-eslint-language-server', '--stdio' },
        root_markers = { '.eslintrc', '.eslintrc.js', '.eslintrc.json', 'eslint.config.js' },
        settings = {
          codeAction = {
            disableRuleComment = { enable = true },
            showDocumentation = { enable = true },
          },
          codeActionOnSave = { enable = true, mode = 'all' },
          format = { enable = true },
        },
      }
      vim.lsp.enable('eslint')

      vim.lsp.config.ts_ls = {
        cmd = { 'typescript-language-server', '--stdio' },
        root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json' },
      }
      vim.lsp.enable('ts_ls')

      vim.lsp.config.jsonls = {
        cmd = { 'vscode-json-language-server', '--stdio' },
        root_markers = { 'package.json' },
        settings = {
          json = {
            validate = { enable = true },
          },
        },
      }
      vim.lsp.enable('jsonls')

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local bufnr = args.buf
          on_attach(nil, bufnr)
        end,
      })
    end,
  },
}
