{ pkgs, ... }:
{
  services.xremap.config.keymap = [
    {
      name = "IM Navigator - Ctrl-Up/Down";
      application = {
        only = [ "QQ" ];
      };
      remap = {
        "M-j" = "C-down";
        "M-k" = "C-up";
        "M-h" = "C-left";
        "M-l" = "Enter";
      };
    }
  ];
  home.packages = with pkgs; [
    nixpaks.qq
  ];
}
