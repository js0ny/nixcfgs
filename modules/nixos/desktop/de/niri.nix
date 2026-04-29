{
  pkgs,
  lib,
  config,
  ...
}:
let
  desktop = config.nixdots.desktop;
in
lib.mkIf (config.nixdots.desktop.enable && builtins.elem "niri" desktop.de) {
  programs.niri = {
    enable = true;
    package = desktop.niri.package;
  };
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    hyprpolkitagent
  ];
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
    config.niri = {
    };
  };
}
