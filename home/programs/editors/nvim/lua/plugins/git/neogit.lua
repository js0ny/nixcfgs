return {
  'NeogitOrg/neogit',
  config = true,
  dependencies = {
    'sindrets/diffview.nvim',
  },
  cmd = {
    'Neogit',
  },
  keys = {
    { '<leader>gg', '<Cmd>Neogit<CR>', desc = 'Neogit' },
  },
}
