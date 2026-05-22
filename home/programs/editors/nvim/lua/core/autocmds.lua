vim.fn.matchadd('Conceal', [[\%u200b]], 10, -1, { conceal = '' })

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*',
  callback = function()
    vim.cmd([[syntax match ShortWord "\<\w\{1,2}\>" contains=@NoSpell]])
  end,
})

-- Highlight on yank
-- https://stackoverflow.com/a/73365602
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Hightlight selection on yank',
  pattern = '*',
  callback = function()
    vim.hl.on_yank({ higroup = 'IncSearch', timeout = 250 })
  end,
})
