{
  pkgs,
  lib,
  osConfig,
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
      Wayland.InputMethod = "${osConfig.i18n.inputMethod.package}/share/applications/fcitx5-wayland-launcher.desktop";
      XWayland.Scale = 1.7;
    };
  };
}
