{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.de;
in
lib.mkIf (config.nixdots.desktop.enable && builtins.elem "kde" cfg) {
  services.desktopManager.plasma6.enable = true;
  environment.systemPackages = with pkgs.kdePackages; [
    akonadi
    korganizer
    kdepim-addons
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    config.kde = {
      default = [
        "kde"
        "gtk"
      ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "kde" ];
      "org.freedesktop.impl.portal.RemoteDesktop" = [ "kde" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "kde" ];
      "org.freedesktop.impl.portal.FileChooser" = [
        "kde"
        "gtk"
      ];
    };
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate # kate and kwrite
  ];
}
