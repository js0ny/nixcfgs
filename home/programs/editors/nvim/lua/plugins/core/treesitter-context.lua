return {

  'nvim-treesitter/nvim-treesitter-context',
  event = 'VeryLazy',
  opts = {
    max_lines = 5,
    mode = 'topline',
  },
  keys = {
    {
      '<leader>tc',
      function()
        require('treesitter-context').toggle()
      end,
      desc = 'Treesitter Context',
    },
  },
  cmd = { 'TSContext' },
}
