return {
  'echasnovski/mini.surround',
  version = false,
  config = function()
    require('mini.surround').setup {
      mappings = {
        add = '<leader>ra',
        delete = '<leader>rd',
        replace = '<leader>rc',
      },
      -- Кастомные окружения для JSX
      custom_surroundings = {
        ['x'] = {
          -- Паттерн для захвата тега и атрибутов: <div className="...">
          input = '^<([%w]+)(.-)>()$',
          output = function()
            -- Запрашиваем у пользователя полный тег (с атрибутами)
            local tag_input = vim.fn.input 'Enter JSX tag (e.g. div className="..."): <'
            if tag_input == '' then
              return nil
            end -- Отмена

            -- Извлекаем имя тега и атрибуты
            local tag_name, attrs = tag_input:match '([%w]+)(.*)'
            if not tag_name then
              return nil
            end

            -- Возвращаем левую и правую части
            return {
              left = '<' .. tag_name .. attrs .. '>',
              right = '</' .. tag_name .. '>',
            }
          end,
        },
      },
    }
  end,
}
