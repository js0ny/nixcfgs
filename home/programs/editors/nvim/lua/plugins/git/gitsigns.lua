return { -- Git Blames, Changes
  'lewis6991/gitsigns.nvim',
  opts = {
    current_line_blame = true,
  },
  event = 'BufReadPre',
  keys = {
    { '<leader>gb', '<cmd>Gitsigns blame<CR>', desc = 'Blame file' },
    { '<leader>gB', '<cmd>Gitsigns toggle_current_line_blame<CR>', desc = 'Toggle line blame' },
    { '[g', '<cmd>Gitsigns prev_hunk<CR>', desc = 'Prev hunk' },
    { ']g', '<cmd>Gitsigns next_hunk<CR>', desc = 'Next hunk' },
  },
}
