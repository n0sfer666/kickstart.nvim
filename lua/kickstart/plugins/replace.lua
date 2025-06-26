return function()
  local dynamicPart = '(.{-})'
  dynamicPart = dynamicPart:gsub('[%(%)%{]', '\\%1')

  local pattern = vim.fn.input 'Search ($$ - dynamic part): '
  pattern = pattern:gsub('[%\\/]', '\\%1')
  pattern = pattern:gsub('%$%$', dynamicPart)
  pattern = pattern -- Заменяем спецсимволы на экранированные', '\\/')

  local replacement = vim.fn.input 'Replace ($$ - dynamic part): '
  local replacemnetParam = 1
  replacement = replacement:gsub('[%\\/]', '\\%1')
  replacement = replacement:gsub('%$%$', function()
    local result = '\\' .. replacemnetParam
    replacemnetParam = replacemnetParam + 1
    return result
  end)

  local cmd = string.format(':%%s/%s/%s/g', pattern, replacement)
  vim.cmd(cmd)
end
