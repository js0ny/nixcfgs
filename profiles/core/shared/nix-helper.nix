{ config, ... }:
let
  flake = config.js0ny.host.flakeDir;
in
{
  programs.nh = {
    enable = true;
    flake = flake;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 3d";
    };
  };
}
