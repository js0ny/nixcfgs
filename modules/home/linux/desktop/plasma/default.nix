{ lib, config, ... }:
let
  iconFixRule = entryName: wmclass: {
    description = "[FIX] Wayland Icon for ${entryName}";
    match = {
      # TODO: Add regex matching
      window-class = {
        value = wmclass;
        type = "exact";
      };
    };
    apply = {
      desktopfile = entryName;
    };
  };
  iconFixList = {
    "virt-manager" = "python3.13 .virt-manager-wrapped";
    "proton.vpn.app.gtk" = "python3.13 .protonvpn-app-wrapped";
    "GameConqueror" = "python3.13 GameConqueror.py";
  };
in
{
  imports = [
    ./files.nix
  ];
  programs.plasma = {
    workspace = {
      iconTheme = config.nixdots.style.icon.dark;
      lookAndFeel = "stylix";

    };
    fonts = {
      fixedWidth.family = "${config.stylix.fonts.monospace.name}";
      fixedWidth.pointSize = 10;
      general.family = "${config.stylix.fonts.sansSerif.name}";
      general.pointSize = 10;
    };
    window-rules = (lib.mapAttrsToList iconFixRule iconFixList);
  };
}
