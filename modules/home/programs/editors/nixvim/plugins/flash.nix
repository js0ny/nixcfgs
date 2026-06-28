{ ... }:
{
  programs.nixvim = {
    plugins.flash = {
      enable = true;
    };
    keymaps = [
      {
        key = "s";
        mode = [
          "n"
          "x"
          "o"
        ];
        action.__raw = ''function() require("flash").jump() end'';
      }
      {
        key = "S";
        mode = [
          "n"
          "x"
          "o"
        ];
        action.__raw = ''function() require("flash").treesitter() end'';
      }
    ];
  };
}
