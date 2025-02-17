return {
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {
        toggler = {
          line = '<leader>cc', -- Toggle line comment
          block = '<leader>bc', -- Toggle block comment
        },
        opleader = {
          line = '<leader>c', -- Comment/uncomment line
          block = '<leader>b', -- Comment/uncomment block
        },
      }
    end,
  },
}
