local M = {}

-- Helper function to escape pattern
local function escape_pattern(text)
  return text:gsub('([%%%[%]%.%^%$%*%+%-%?])', '%%%1')
end

-- Helper function to escape replacement string
local function escape_replace(text)
  return text:gsub('%%', '%%%%')
end

-- Helper function to count matches in text
local function count_matches(text, pattern)
  local count = 0
  for _ in text:gmatch(pattern) do
    count = count + 1
  end
  return count
end

-- Helper function to safely read file
local function read_file_lines(file)
  local f = io.open(file, 'r')
  if not f then
    return {}
  end
  local lines = {}
  for line in f:lines() do
    table.insert(lines, line)
  end
  f:close()
  return lines
end

-- Helper function to safely write file
local function write_file_lines(file, lines)
  local f = io.open(file, 'w')
  if not f then
    return false
  end
  f:write(table.concat(lines, '\n'))
  f:close()
  return true
end

-- Replace in current buffer
local function replace_current_buffer(confirm)
  local search = vim.fn.input 'Search pattern: '
  if search == '' then
    return
  end

  local replace = vim.fn.input 'Replacement: '
  local flags = confirm and 'gc' or 'g'
  local escaped_search = escape_pattern(search)
  local escaped_replace = escape_replace(replace)
  local total = 0

  -- First count matches
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  for _, line in ipairs(lines) do
    total = total + count_matches(line, escaped_search)
  end

  if total == 0 then
    vim.notify(string.format('Не найдено ни одного совпадения для "%s"', search), vim.log.levels.WARN)
    return
  end

  -- Ask for confirmation if needed
  if confirm then
    local response = vim.fn.input(string.format('Replace %d occurrences of "%s" with "%s"? (y/n): ', total, search, replace))
    if response:lower() ~= 'y' then
      return
    end
  end

  vim.cmd('keepjumps %s/' .. escaped_search .. '/' .. escaped_replace .. '/' .. flags)
  vim.notify(string.format('Replaced "%s" → "%s" in buffer (%d replacements)', search, replace, total))
end

-- Replace in all loaded buffers
local function replace_all_buffers(confirm)
  local search = vim.fn.input 'Search pattern: '
  if search == '' then
    return
  end

  local replace = vim.fn.input 'Replacement: '
  local flags = confirm and 'gc' or 'g'
  local escaped_search = escape_pattern(search)
  local escaped_replace = escape_replace(replace)
  local total = 0

  -- First count matches in all buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'modifiable') then
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      for _, line in ipairs(lines) do
        total = total + count_matches(line, escaped_search)
      end
    end
  end

  if total == 0 then
    vim.notify(string.format('Не найдено ни одного совпадения для "%s"', search), vim.log.levels.WARN)
    return
  end

  -- Ask for confirmation if needed
  if confirm then
    local response = vim.fn.input(string.format('Replace %d occurrences of "%s" with "%s" in all buffers? (y/n): ', total, search, replace))
    if response:lower() ~= 'y' then
      return
    end
  end

  -- Perform replacement
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'modifiable') then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd('keepjumps %s/' .. escaped_search .. '/' .. escaped_replace .. '/' .. flags)
      end)
    end
  end

  vim.notify(string.format('Replaced %d "%s" → "%s" across all buffers', total, search, replace))
end

-- Replace in project files
local function replace_project(confirm)
  local search = vim.fn.input 'Search pattern: '
  if search == '' then
    return
  end

  local replace = vim.fn.input 'Replacement: '
  local escaped_search = escape_pattern(search)
  local escaped_replace = escape_replace(replace)
  local files = vim.fn.glob('**/*', true, true) -- recursive file listing
  local total = 0
  local processed_files = 0

  -- First count matches in all files
  for _, file in ipairs(files) do
    if vim.fn.filereadable(file) == 1 then
      local lines = read_file_lines(file)
      for _, line in ipairs(lines) do
        total = total + count_matches(line, escaped_search)
      end
    end
  end

  if total == 0 then
    vim.notify(string.format('Не найдено ни одного совпадения для "%s"', search), vim.log.levels.WARN)
    return
  end

  -- If confirm is true, ask for confirmation
  if confirm then
    local response = vim.fn.input(string.format('Replace %d occurrences of "%s" with "%s" in %d files? (y/n): ', total, search, replace, #files))
    if response:lower() ~= 'y' then
      return
    end
  end

  -- Perform replacement
  for _, file in ipairs(files) do
    if vim.fn.filereadable(file) == 1 then
      local lines = read_file_lines(file)
      local changed = false

      for i, line in ipairs(lines) do
        local new_line, count = line:gsub(escaped_search, escaped_replace)
        if count > 0 then
          lines[i] = new_line
          changed = true
        end
      end

      if changed then
        if write_file_lines(file, lines) then
          processed_files = processed_files + 1
        else
          vim.notify(string.format('Failed to write file: %s', file), vim.log.levels.ERROR)
        end
      end
    end
  end

  vim.notify(string.format('Replaced %d "%s" → "%s" in %d/%d files', total, search, replace, processed_files, #files))
end

function M.setup()
  -- Current buffer
  vim.keymap.set('n', '<leader>rr', function()
    replace_current_buffer(false)
  end, { desc = 'Replace in buffer (no confirm)' })
  vim.keymap.set('n', '<leader>rR', function()
    replace_current_buffer(true)
  end, { desc = 'Replace in buffer (with confirm)' })

  -- All buffers
  vim.keymap.set('n', '<leader>rB', '<Nop>', { desc = 'Replace in opened buffers' })
  vim.keymap.set('n', '<leader>rB!', function()
    replace_all_buffers(false)
  end, { desc = 'Replace in all buffers (no confirm)' })
  vim.keymap.set('n', '<leader>rBC', function()
    replace_all_buffers(true)
  end, { desc = 'Replace in all buffers (with confirm)' })

  -- Project files
  vim.keymap.set('n', '<leader>rP', '<Nop>', { desc = 'Replace in project' })
  vim.keymap.set('n', '<leader>rP!', function()
    replace_project(false)
  end, { desc = 'Replace in project files (no confirm)' })
  vim.keymap.set('n', '<leader>rPC', function()
    replace_project(true)
  end, { desc = 'Replace in project files (with confirm)' })
end

return M
