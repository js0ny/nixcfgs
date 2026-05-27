{ ... }:
{
  programs.nixvim = {
    clipboard = {
      register = "unnamedplus";
    };

    extraConfigLua = ''
      -- OSC52 clipboard over SSH
      local is_ssh = vim.env.SSH_CLIENT ~= nil or vim.env.SSH_TTY ~= nil
      if is_ssh then
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

      -- Spell file
      local spell_dir = vim.fn.stdpath('data') .. '/spell'
      if vim.fn.isdirectory(spell_dir) == 0 then
        vim.fn.mkdir(spell_dir, 'p')
      end
      vim.opt.spellfile = spell_dir .. '/en.utf-8.add'
    '';
  };
}
