-- Source all lsp definition in (local overrides)
-- ~/.config/nvim/lsp/*.lua
local lsp_configs = {}
for _, v in ipairs(vim.api.nvim_get_runtime_file('lsp/*', true)) do
  local name = vim.fn.fnamemodify(v, ':t:r')
  lsp_configs[name] = true
end

if Config.enable_all_lsps then
  local alllsps = require('lazy.core.config').plugins['nvim-lspconfig'].dir .. '/lsp'
  for _, v in ipairs(vim.fn.readdir(alllsps)) do
    local name = vim.fn.fnamemodify(v, ':t:r')
    lsp_configs[name] = true
  end
end

vim.lsp.enable(vim.tbl_keys(lsp_configs))
