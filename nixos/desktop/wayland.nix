{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.linux.display;
in
lib.mkIf (cfg == "wayland") {
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
  programs.gpu-screen-recorder.enable = true;
  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
  };
}
