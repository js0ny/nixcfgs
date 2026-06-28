-- options/stdpath.lua
-- Keep all data that should be persisted in $XDG_DATA_PATH/nvim.

local spell_dir = vim.fn.stdpath('data') .. '/spell'
if vim.fn.isdirectory(spell_dir) == 0 then
  vim.fn.mkdir(spell_dir, 'p')
end

vim.opt.spellfile = spell_dir .. '/en.utf-8.add'
