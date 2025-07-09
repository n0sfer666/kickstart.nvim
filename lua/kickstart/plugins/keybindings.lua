return {
  -- basic
  --
  vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true }),
  vim.keymap.set('i', 'оо', '<Esc>', { noremap = true, silent = true }),
  vim.keymap.set('n', 'U', '<C-r>', { noremap = true, silent = true }),
  -- add new line and move cursor
  vim.keymap.set('n', '<CR>', 'm`o<Esc>``'),
  vim.keymap.set('n', '<S-CR>', 'm`O<Esc>``'),

  -- markdownPreview
  vim.keymap.set('n', '<leader>md', ':MarkdownPreviewToggle<CR>', { noremap = true, silent = true, desc = 'Markdown Preview' }),

  -- Buffers
  --
  -- Force Close
  vim.keymap.set('n', '<leader>ba', ':%bd | e#<CR>', { noremap = true, silent = true, desc = 'Delete [A]ll Buffer' }),
  -- Force Delete from Memory
  vim.keymap.set('n', '<leader>bd', ':bw!<CR>', { noremap = true, silent = true, desc = '[D]elete Buffer' }),

  -- Refactoring
  --
  -- move selected code downer
  vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv"),
  -- move selected code upper
  vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv"),
  -- Показ типа переменной по <K>
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show variable info (LSP)' }),
  -- Переход к определению по <gd>
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' }),
}
