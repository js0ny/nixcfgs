{ lib, ... }:
{
  options.nixdots.keymaps = {
    enable = lib.mkEnableOption "Enable keymaps modifications";
    keyd = {
      enable = lib.mkEnableOption "Enable keyd for advanced keyboard remapping.";
    };
    xremap = {
      enable = lib.mkEnableOption "Enable xremap for customizable key remapping. This is an alternative to keyd with better wayland support.";
    };
  };
}
