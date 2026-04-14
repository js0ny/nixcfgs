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
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate # kate and kwrite
  ];
}
