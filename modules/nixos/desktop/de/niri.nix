{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.de;
in
lib.mkIf (config.nixdots.desktop.enable && builtins.elem "niri" cfg) {
  programs.niri.enable = true;
  environment.systemPackages = with pkgs; [
    xwayland-satellite
    hyprpolkitagent
  ];
}
