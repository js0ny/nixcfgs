{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.machine.displayProtocol;
in
lib.mkIf (cfg == "wayland") {
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
}
