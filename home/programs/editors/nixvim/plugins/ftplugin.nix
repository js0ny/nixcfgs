{ config, pkgs, ... }:
let
  cfg = config.programs.nixvim;
in
{
  xdg.configFile = {
    "nvim/after/ftplugin/lua.lua".text = /* lua */ ''
      vim.bo.shiftwidth = 2
      vim.bo.softtabstop = 2
      vim.bo.expandtab = true

      local bufmap = {
        {
          mode = 'n',
          keys = '<LocalLeader>c',
          cmd = '<cmd>e ~/.config/nvim/after/ftplugin/lua.lua<CR>',
          opt = { desc = 'Edit ftplugin' },
        },
        {
          mode = 'n',
          keys = '<LocalLeader>l',
          cmd = '<cmd>luafile %<CR>',
          opt = { desc = 'Reload current buffer' },
        },
      }

      for _, map in ipairs(bufmap) do
        vim.keymap.set(map.mode, map.keys, map.cmd, vim.tbl_extend('force', map.opt or {}, { buffer = true }))
      end
    '';

    "nvim/after/ftplugin/markdown.lua".text = /* lua */ ''
      vim.bo.shiftwidth = 2
      vim.bo.softtabstop = 2
      vim.bo.expandtab = true

      vim.opt_local.spelllang = { 'en_us', 'en_gb', 'cjk' }
      vim.opt_local.spell = true

      local bufmap = {
        { mode = 'x', keys = '<LocalLeader>i', cmd = 'c*<C-r>"*', opt = { desc = 'Add italic to selected text' } },
        { mode = 'x', keys = '<LocalLeader>b', cmd = 'c**<C-r>"**', opt = { desc = 'Add bold to selected text' } },
        { mode = 'x', keys = 'mc', cmd = 'c`<CR><C-r>"<CR>`', opt = { desc = 'Add code block to selected text' } },
        { mode = 'x', keys = '<LocalLeader>D', cmd = 'c~~<C-r>"~~', opt = { desc = 'Add strikethrough to selected text' } },
        { mode = 'x', keys = '<LocalLeader>h', cmd = 'c==<C-r>"==', opt = { desc = 'Add highlight to selected text' } },
        { mode = 'n', keys = 'J', cmd = '<Nop>' },
        { mode = 'n', keys = '<Tab>', cmd = '<Cmd>silent! normal! za<CR>', opt = { desc = 'Toggle folding under current level (silent)' } },
        { mode = 'n', keys = '<LocalLeader>c', cmd = '<cmd>e ~/.config/nvim/after/ftplugin/markdown.lua<CR>', opt = { desc = 'Edit ftplugin' } },
      }

      for _, map in ipairs(bufmap) do
        vim.keymap.set(map.mode, map.keys, map.cmd, vim.tbl_extend('force', map.opt or {}, { buffer = true }))
      end
    '';

    "nvim/after/ftplugin/nix.lua".text = /* lua */ ''
      vim.b.match_words = [[\<let\>:\<in\>]]
    '';

    "nvim/after/ftplugin/typst.lua".text = /* lua */ ''
      vim.bo.shiftwidth = 2
      vim.bo.softtabstop = 2
      vim.bo.expandtab = true

      vim.opt_local.spelllang = { 'en_us', 'cjk' }
      vim.opt_local.spell = true

      local bufmap = {
        { mode = 'n', keys = '<LocalLeader>x', cmd = '<cmd>TypstPreview<CR>', opt = { desc = 'Preview in Browser' } },
        { mode = 'n', keys = '<LocalLeader>c', cmd = '<cmd>e ~/.config/nvim/after/ftplugin/typst.lua<CR>', opt = { desc = 'Edit ftplugin' } },
      }

      for _, map in ipairs(bufmap) do
        vim.keymap.set(map.mode, map.keys, map.cmd, vim.tbl_extend('force', map.opt or {}, { buffer = true }))
      end
    '';
  };
}
