--- Folding
-- Fold with tree-sitter
-- _G.hybrid_foldexpr = function()
--   local line = vim.fn.getline(vim.v.lnum)
--
--   if string.find(line, '{{{', 1, true) or string.find(line, '#region', 1, true) then
--     return 'a1'
--   end
--
--   if string.find(line, '}}}', 1, true) or string.find(line, '#endregion', 1, true) then
--     return 's1'
--   end
--
--   return vim.treesitter.foldexpr()
-- end

function _G.ConfigFoldText()
  local hidden_count = vim.v.foldend - vim.v.foldstart
  local parts = { { vim.fn.getline(vim.v.foldstart), 'ConfigFoldPreview' } }
  local end_text = vim.trim(vim.fn.getline(vim.v.foldend))
  if end_text ~= '' then
    table.insert(parts, { ' ⋯ ', 'ConfigFoldMuted' })
    table.insert(parts, { end_text, 'ConfigFoldPreview' })
  end

  table.insert(parts, { '   ↙️ [' .. hidden_count .. ' lines hidden]', 'ConfigFoldTail' })
  return parts
end

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.foldtext = 'v:lua.ConfigFoldText()'
