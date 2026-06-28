return {
  'akinsho/toggleterm.nvim',
  keys = {
    { '<leader>!', '<cmd>ToggleTerm direction=float<CR>', desc = 'Toggle Terminal' },
    { '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', desc = 'Toggle Terminal' },
    { '<leader>tt', '<cmd>ToggleTerm<CR>', desc = 'Spawn a Terminal' },
  },
  cmd = {
    'ToggleTerm',
    'LazyGit',
  },
  init = function()
    vim.api.nvim_create_user_command('LazyGit', function()
      require('toggleterm.terminal').Terminal:new({ cmd = 'lazygit', direction = 'float' }):toggle()
    end, {})
  end,
  opts = {},
}
