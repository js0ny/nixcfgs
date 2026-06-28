local utils = require('core.utils')
--- Lsp related Keymaps
vim.keymap.del({ 'n', 'x' }, 'gra')
vim.keymap.del({ 'n' }, 'gri')

local maps = {
  {
    mode = 'n',
    keys = 'q:',
    cmd = ':',
    opts = { desc = 'Disable cmd window' },
  },
  {
    mode = 'v',
    keys = '<',
    cmd = '<gv',
    opts = { desc = 'Indent left and keep selection' },
  },
  {
    mode = 'n',
    keys = '<Tab>',
    cmd = '%',
    opts = { desc = 'Jump to matching pair' },
  },
  {
    mode = 'v',
    keys = '>',
    cmd = '>gv',
    opts = { desc = 'Indent right and keep selection' },
  },
  -- https://github.com/LazyVim/LazyVim/blob/d1529f650fdd89cb620258bdeca5ed7b558420c7/lua/lazyvim/config/keymaps.lua#L60
  {
    keys = '<Esc>',
    cmd = '<Cmd>nohlsearch<Bar>diffupdate<CR>',
    opts = { desc = 'Clear Search Highlight' },
  },
  {
    mode = 't',
    keys = '<C-w>',
    cmd = '<C-\\><C-n><C-w>',
    opts = { desc = 'Terminal: passthrough C-w directly' },
  },
}

local function smart_split(func, reverse)
  local width = vim.api.nvim_win_get_width(0)
  if width > 80 and not reverse then
    vim.api.nvim_command('vsp')
  else
    vim.api.nvim_command('sp')
  end
  func()
end


-- stylua: ignore start
local lspkeys = {
  -- { keys = "gd",        cmd = vim.lsp.buf.definition,     opts = { desc = "Goto Definition" } },
  { keys = "<C-CR>",    cmd = vim.lsp.buf.definition,     opts = { desc = "Goto Definition" } },
  { keys = "gi",        cmd = vim.lsp.buf.implementation, opts = { desc = "Goto Implementation" } },
  { keys = "<leader>,", cmd = vim.lsp.buf.code_action,    opts = { desc = "Code Action" } },
  { keys = "ga",        cmd = vim.lsp.buf.code_action,    opts = { desc = "Code Action" } },
  { keys = "g.",        cmd = vim.lsp.buf.code_action,    opts = { desc = "Code Action" } },
  { keys = "gh",        cmd = vim.lsp.buf.hover,          opts = { desc = "Show hover" } },
  -- [c]hange [d]efinition
  { keys = "cd",        cmd = vim.lsp.buf.rename,         opts = { desc = "Rename symbol under cursor" } },
  { keys = "<C-w>d", cmd = function() smart_split(vim.lsp.buf.definition) end, opts = { desc = "Goto Definition (Smart Split)" } },
  { keys = "<C-w>D", cmd = function() smart_split(vim.lsp.buf.declaration, true) end, opts = { desc = "Goto Declaration (Smart Split)" } },
}
-- stylua: ignore end

utils.set_keymaps(maps)
utils.set_keymaps(lspkeys)
