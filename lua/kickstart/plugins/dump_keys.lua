-- Где-то в конце файла, после lazy.setup()
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local function DumpKeymaps()
      local file = io.open(vim.fn.expand '~' .. '/.config/nvim/doc/nvim_keymaps.txt', 'w')
      if not file then
        return
      end

      local modes = { 'n', 'v', 'i', 'x', 's', 'o', 't', 'c' }

      for _, mode in ipairs(modes) do
        file:write('\n===== ' .. mode:upper() .. ' MODE =====\n')
        local keymaps = vim.api.nvim_get_keymap(mode)

        for _, km in ipairs(keymaps) do
          file:write(
            string.format('%-10s → %-20s | %-30s | %s\n', km.lhs, km.rhs or '', km.desc or 'no description', km.callback and 'Lua callback' or 'Vim script')
          )
        end
      end

      file:close()
      vim.notify('Keymaps dumped to ~/.config/nvim/doc/nvim_keymaps.txt', vim.log.levels.INFO)
    end

    vim.api.nvim_create_user_command('DumpKeymaps', DumpKeymaps, {})
  end,
  once = true,
})
