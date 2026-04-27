{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdots.devenvs.latex;
in
lib.mkIf cfg.enable {
  home.packages = with pkgs; [
    corefonts
  ];
}
