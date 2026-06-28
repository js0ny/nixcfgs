{ ... }:
{
  programs.nixvim = {
    plugins.nvim-ufo = {
      enable = true;
    };

    keymaps = [
      {
        key = "zR";
        action.__raw = "function() require('ufo').openAllFolds() end";
        options.desc = "Open all folds";
      }
      {
        key = "zM";
        action.__raw = "function() require('ufo').closeAllFolds() end";
        options.desc = "Close all folds";
      }
    ];

    extraConfigLua = ''
      function _G.ConfigFoldText()
        local hidden_count = vim.v.foldend - vim.v.foldstart
        local parts = { { vim.fn.getline(vim.v.foldstart), 'ConfigFoldPreview' } }
        local end_text = vim.trim(vim.fn.getline(vim.v.foldend))
        if end_text ~= "" then
          table.insert(parts, { ' ... ', 'ConfigFoldMuted' })
          table.insert(parts, { end_text, 'ConfigFoldPreview' })
        end
        table.insert(parts, { '   [ ' .. hidden_count .. ' lines hidden]', 'ConfigFoldTail' })
        return parts
      end

      vim.opt.foldtext = 'v:lua.ConfigFoldText()'
    '';
  };
}
