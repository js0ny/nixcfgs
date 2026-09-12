{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.boot.lanzaboote.enable;
in
lib.mkIf cfg {
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote.pkiBundle = "/var/lib/sbctl";

  environment.systemPackages = with pkgs; [ sbctl ];
  js0ny.persist.stores.state.directories = [ "/var/lib/sbctl" ];
}
