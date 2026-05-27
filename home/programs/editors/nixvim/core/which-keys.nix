{ ... }:
{
  programs.nixvim = {
    plugins.which-key = {
      enable = true;
      settings = {
        preset.__raw = "_G.IS_TTY and 'classic' or 'modern'";
      };
    };

    keymaps = [
      {
        key = "<leader>H";
        action.__raw = "function() require('which-key').show({ global = false }) end";
        options.desc = "Buffer Local Keymaps (which-key)";
      }
    ];
  };
}
