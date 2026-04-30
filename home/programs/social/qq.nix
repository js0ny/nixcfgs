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
      };
    }
  ];
  home.packages = with pkgs; [
    nixpaks.qq
  ];
}
