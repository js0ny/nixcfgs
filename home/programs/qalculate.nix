{ pkgs, config, ... }:
let
  features = config.nixdots.features;
in
{
  programs.qalculate = {
    enable = false;
    package = if (features.preferQt && pkgs.stdenv.isLinux) then pkgs.qalculate-qt else pkgs.qalculate;
  };
}
