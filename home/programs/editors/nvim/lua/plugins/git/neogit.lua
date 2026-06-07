return {
  'NeogitOrg/neogit',
  config = true,
  dependencies = {
    'esmuellert/codediff.nvim',
  },
  cmd = {
    'Neogit',
  },
  keys = {
    { '<leader>gg', '<Cmd>Neogit<CR>', desc = 'Neogit' },
    { '<C-S-g>', '<Cmd>Neogit<CR>', desc = 'Neogit' },
  },
}
