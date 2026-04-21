{ config, ... }:
let
  flake = config.nixdots.core.flakeDir;
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
