_G.Config = require('core.env')

local custom_vars = vim.fn.stdpath('config') .. '/env.custom.lua'

if vim.uv.fs_stat(custom_vars) then
  dofile(custom_vars)
end

require('core.options')
require('core.clipboard')
require('core.input')
require('core.stdpath')
require('core.keymaps')
require('core.autocmds')
require('core.diagnostics')
require('core.commands')

require('core.lazy')

require('lazy').setup({
  spec = {
    { import = 'plugins.core' },
    { import = 'plugins.lang' },
    { import = 'plugins.git' },
    { import = 'plugins.tools' },
    { import = 'plugins.appearance' },
  },
  checker = { enabled = false },
})

require('core.lsp')

require('core.fold')

if
  not Config.external_deps
  and not package.loaded['mini.base16']
  and not package.loaded['base16-colorscheme']
then
  vim.cmd.colorscheme('kanagawa-wave')
end
