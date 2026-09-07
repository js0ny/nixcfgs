{
  pkgs,
  lib,
  ...
}:
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
    configFile.kwinrc = {
      Wayland.InputMethod = "${pkgs.kdePackages.fcitx5-with-addons}/share/applications/fcitx5-wayland-launcher.desktop";
      XWayland.Scale = 1.7;
    };
  };
}
