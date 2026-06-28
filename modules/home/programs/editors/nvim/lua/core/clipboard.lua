-- ==========================================
-- Clipboard Integration
-- ==========================================

local is_ssh = vim.env.SSH_CLIENT ~= nil or vim.env.SSH_TTY ~= nil

if vim.fn.has('wsl') == 1 then
  local win32yank = Config.wsl_bindir and (Config.wsl_bindir .. '/win32yank.exe')
    or vim.fn.exepath('win32yank.exe')

  vim.g.clipboard = {
    name = 'win32yank-wsl',
    copy = {
      ['+'] = win32yank .. ' -i --crlf',
      ['*'] = win32yank .. ' -i --crlf',
    },
    paste = {
      ['+'] = win32yank .. ' -o --lf',

      ['*'] = win32yank .. ' -o --lf',
    },

    cache_enabled = 0,
  }
end

if is_ssh then
  -- Utilise native OSC 52 support for clipboard synchronisation over SSH.
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end

-- Force Neovim to use the system clipboard ('+') as the default register.
vim.opt.clipboard = 'unnamedplus'
