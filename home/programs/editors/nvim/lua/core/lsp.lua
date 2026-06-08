-- Source all lsp definition in (local overrides)
-- ~/.config/nvim/lsp/*.lua

local lsp_configs = {}

local disabled_lsps = {
  'gitlab_duo', -- https://docs.gitlab.com/user/gitlab_duo/
}
local enabled_lsps = {
  -- keep-sorted start
  'clangd',
  'gopls',
  'lua_ls',
  'nil_ls',
  'nixd',
  'pyright',
  'rust_analyzer',
  'ts_ls',
  -- keep-sorted end
}

vim.tbl_map(function(ls)
  lsp_configs[ls] = true
end, enabled_lsps)

vim.lsp.enable(enabled_lsps)

for _, v in ipairs(vim.api.nvim_get_runtime_file('lsp/*', true)) do
  local name = vim.fn.fnamemodify(v, ':t:r')
  lsp_configs[name] = true
end

if Config.enable_all_lsps then
  local alllsps = require('lazy.core.config').plugins['nvim-lspconfig'].dir .. '/lsp'
  for _, v in ipairs(vim.fn.readdir(alllsps)) do
    local name = vim.fn.fnamemodify(v, ':t:r')
    if vim.tbl_contains(disabled_lsps, name) then
      lsp_configs[name] = nil
    else
      lsp_configs[name] = true
    end
  end
end

vim.lsp.enable(vim.tbl_keys(lsp_configs))

vim.api.nvim_create_user_command('LspLog', function()
  vim.cmd.tabedit(vim.fn.fnameescape(vim.lsp.log.get_filename()))
end, { desc = 'Open LSP log file' })
