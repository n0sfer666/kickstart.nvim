return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    luasnip.add_snippets('typescriptreact', {
      luasnip.snippet('cl', {
        luasnip.text_node 'className={',
        luasnip.insert_node(1),
        luasnip.text_node '}',
      }),
      luasnip.snippet('cn', {
        luasnip.text_node "import cn from 'classnames'",
      }),
    })

    luasnip.add_snippets('javascriptreact', {
      luasnip.snippet('cl', {
        luasnip.text_node 'className={',
        luasnip.insert_node(1),
        luasnip.text_node '}',
      }),
      luasnip.snippet('cn', {
        luasnip.text_node "import cn from 'classnames'",
      }),
    })

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm { select = true },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'luasnip', priority = 1000 },
        { name = 'nvim_lsp', priority = 500 },
        { name = 'path', priority = 300 },
        { name = 'buffer', priority = 100, keyword_length = 3 },
      },
      formatting = {
        format = function(entry, vim_item)
          vim_item.menu = ({
            luasnip = '[Snippet]',
            nvim_lsp = '[LSP]',
            buffer = '[Buffer]',
            path = '[Path]',
          })[entry.source.name]
          return vim_item
        end,
      },
    }

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    vim.lsp.config.cssls = {
      cmd = { 'vscode-css-language-server', '--stdio' },
      filetypes = { 'css', 'scss', 'less' },
      root_markers = { 'package.json' },
      capabilities = capabilities,
    }
    vim.lsp.enable 'cssls'

    vim.lsp.config.emmet_ls = {
      cmd = { 'emmet-ls', '--stdio' },
      filetypes = { 'html', 'css', 'scss', 'javascriptreact', 'typescriptreact' },
      root_markers = { 'package.json' },
      capabilities = capabilities,
    }
    vim.lsp.enable 'emmet_ls'
  end,
}
