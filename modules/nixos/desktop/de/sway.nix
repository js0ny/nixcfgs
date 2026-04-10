{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.de;
in
lib.mkIf (config.nixdots.desktop.enable && builtins.elem "sway" cfg) {
  programs.sway.enable = true;
  programs.sway.xwayland.enable = true;
  services.xremap.withWlroots = true;
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-wlr
  ];
}
