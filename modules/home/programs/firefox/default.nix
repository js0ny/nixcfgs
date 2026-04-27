{
  pkgs,
  lib,
  config,
  ...
}:
let
  profile = config.nixdefs.consts.firefox.profileDir;
in
{
  imports = [
    ./cookie-autodelete.nix
    ./surfingkeys.nix
  ];
  programs.firefox.configPath = profile;
}
