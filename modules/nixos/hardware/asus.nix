{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.laptop.asus;
in
lib.mkIf cfg {
  environment.systemPackages = with pkgs; [
    asusctl
    supergfxctl
  ];

  services.asusd.enable = true;
  services.supergfxd.enable = true;
}
