return {
  'folke/todo-comments.nvim',
  cmd = { 'TodoTrouble', 'TodoQuickFix', 'TodoLocList', 'TodoSnacks' },
  event = 'BufRead',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {},
}
