-- plugins/autocomplete.lua
return {
  -- Основной плагин автодополнения
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- Источники данных
    'hrsh7th/cmp-nvim-lsp', -- LSP источник
    'hrsh7th/cmp-buffer', -- Буферный источник
    'hrsh7th/cmp-path', -- Источник путей
    'hrsh7th/cmp-cmdline', -- Источник командной строки
    'saadparwaiz1/cmp_luasnip', -- Поддержка luasnip
    -- Фрагменты кода
    'L3MON4D3/LuaSnip',
    -- Дополнительные источники
    'hrsh7th/cmp-nvim-lua', -- Для Lua конфигов
    'hrsh7th/cmp-calc', -- Математические вычисления
    'f3fora/cmp-spell', -- Проверка орфографии
  },
  config = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'

    -- Загрузка дружественных фрагментов
    -- НАСТРОЙКА EMMET-VIM
    vim.g.emmet_leader_key = '<C-y>' -- Клавиша активации Emmet

    -- КАСТОМНЫЕ СНИППЕТЫ ДЛЯ TSX
    require('luasnip').add_snippets('typescriptreact', {
      luasnip.parser.parse_snippet('log', 'console.log(${0})'),
      luasnip.parser.parse_snippet(
        'rfc',
        "import React, { FC } from 'react';\n\ntype Props = {\n\n}\n\nexport const ${1:ComponentName}: FC<Props> = () => {\nreturn (\n{/* delete and do the thing */}\n)}"
      ),
      luasnip.parser.parse_snippet('di', '<div>${0}</div>'),
      luasnip.parser.parse_snippet('p', '<p>${0}</p>'),
      luasnip.parser.parse_snippet('cl', 'className={${0}}'),
      luasnip.parser.parse_snippet('cn', "import cn from 'classnames'"),
      luasnip.parser.parse_snippet('state', 'const [${1:state}, set${1^:State}] = useState(${2:initialValue});'),
      luasnip.parser.parse_snippet('useEffect', 'useEffect(() => {\n  ${0}\n}, [${1:dependencies}]);'),
    })
    -- КАСТОМНЫЕ СНИППЕТЫ ДЛЯ TS
    require('luasnip').add_snippets('typescript', {
      luasnip.parser.parse_snippet('log', 'console.log(${0})'),
    })
    -- НАСТРОЙКА CMP
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm { select = true },
        -- Навигация по фрагментам
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
      sources = cmp.config.sources {
        { name = 'nvim_lsp' }, -- LSP источник
        { name = 'luasnip' }, -- Фрагменты
        { name = 'buffer' }, -- Текущий буфер
        { name = 'spell' }, -- Орфография
      },
      formatting = {
        format = function(entry, vim_item)
          -- Добавляем иконки к различным типам источников
          local icons = {
            Text = '󰉿',
            Method = '󰆧',
            Function = '󰊕',
            Constructor = '',
            Field = '󰜢',
            Variable = '󰀫',
            Class = '󰠱',
            Interface = '',
            Module = '',
            Property = '󰜢',
            Unit = '',
            Value = '󰎠',
            Enum = '',
            Keyword = '󰌋',
            Snippet = '',
            Color = '󰏘',
            File = '󰈙',
            Reference = '',
            Folder = '󰉋',
            EnumMember = '',
            Constant = '󰏿',
            Struct = '',
            Event = '',
            Operator = '󰆕',
            TypeParameter = '󰅲',
          }
          vim_item.kind = string.format('%s %s', icons[vim_item.kind], vim_item.kind)
          return vim_item
        end,
      },
      experimental = {
        ghost_text = false, -- Показывать призрачный текст
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    }
    -- Конфигурация для командной строки
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources {
        { name = 'cmdline' },
      },
    })
    local lspconfig = require 'lspconfig'
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    lspconfig.cssls.setup {
      capabilities = capabilities,
      filetypes = { 'css', 'scss', 'less' },
      settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
      },
    }
    lspconfig.emmet_ls.setup {
      capabilities = capabilities,
      filetypes = { 'html', 'css', 'scss', 'javascriptreact', 'typescriptreact' },
    }
  end,
}
