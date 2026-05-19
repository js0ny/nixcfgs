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
  environment.systemPackages = with pkgs; [ sbctl ];
  nixdots.persist.system.directories = [ "/var/lib/sbctl" ];
}
