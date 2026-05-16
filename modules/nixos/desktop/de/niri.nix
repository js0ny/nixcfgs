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
  environment.systemPackages = with pkgs; [ xwayland-satellite ];
}
