{
  pkgs,
  lib,
  ...
}:
let
  iconFixRule = entryName: wmclass: {
    description = "Fix icon for ${entryName}";
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
  programs.plasma = {
    kwin = {
      virtualDesktops.number = 9;
      titlebarButtons = {
        left = [
          "more-window-actions"
          "on-all-desktops"
          "keep-above-windows"
        ];
      };
    };
    window-rules = (lib.mapAttrsToList iconFixRule iconFixList) ++ [
      {

        description = "mpv float preset";
        match = {
          window-class = {
            value = "mpv";
            type = "exact";
          };
        };
        apply = {
          above = true;
        };
      }
    ];
    configFile.kwinrc = {
      Wayland.InputMethod = "${pkgs.kdePackages.fcitx5-with-addons}/share/applications/fcitx5-wayland-launcher.desktop";
      XWayland.Scale = 1.7;
    };
  };
}
/*
  TODO:
  [a0cac373-462b-4b7e-a796-13e67404e7db]
  Description=float - mpv
  above=true
  aboverule=3
  opacityinactive=90
  opacityinactiverule=2
  skippagerrule=3
  wmclass=mpv
  wmclassmatch=1
*/
