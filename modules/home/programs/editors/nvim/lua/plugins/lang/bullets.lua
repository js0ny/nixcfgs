return {
  'bullets-vim/bullets.vim',
  ft = { 'markdown', 'typst', 'gitcommit' },
  init = function()
    vim.g.bullets_enabled_file_types = { 'markdown', 'typst', 'gitcommit' }
  end,
}
