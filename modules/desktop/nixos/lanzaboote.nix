{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.linux.lanzaboote;
in
lib.mkIf cfg {
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  environment.systemPackages = with pkgs; [ sbctl ];
  nixdots.persist.system.directories = [ "/var/lib/sbctl" ];
}
