return {
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {
        toggler = {
          line = '<leader>cc', -- Toggle line comment
          block = '<leader>cb', -- Toggle block comment
        },
        opleader = {
          line = '<leader>cc', -- Comment/uncomment line
          block = '<leader>cb', -- Comment/uncomment block
        },
      }
    end,
  },
}
