{
  config,
  inputs,
  pkgs,
  ...
}:
let
  flake = config.nixdots.core.flakeDir;
in
{
  programs.nh = {
    enable = true;
    flake = flake;
    package = inputs.nh.packages.${pkgs.stdenv.hostPlatform.system}.nh;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 3d";
    };
  };
}
