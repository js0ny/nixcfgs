{ ... }:
{
  programs.nixvim = {
    plugins.snacks = {
      enable = true;
      globals = {
        loaded_netrw = 1;
        loaded_netrwPlugin = 1;
      };
      settings = {
        explorer.enabled = true;
      };
    };

    keymaps = [
      {
        key = "<leader>e";
        action.__raw = ''function() require("snacks").explorer() end'';
        options.desc = "File Explorer";
      }
      {
        key = "<leader>ft";
        action.__raw = ''function() require("snacks").explorer() end'';
        options.desc = "Toggle File Tree";
      }
    ];
  };
}
