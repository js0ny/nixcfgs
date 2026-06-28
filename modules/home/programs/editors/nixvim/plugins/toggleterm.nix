{ ... }:
{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;
    };
    keymaps = [
      {
        key = "<leader>!";
        action = "<cmd>ToggleTerm direction=float<CR>";
        options.desc = "Toggle Terminal";
      }
    ];
  };
}
