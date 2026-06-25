# Run nightly:
# nix run "github:nix-community/flake-firefox-nightly#firefox-nightly-bin"
{
  pkgs,
  lib,
  config,
  myLib,
  ...
}:
let
  profile = config.nixdefs.consts.firefox.profileDir;
in
{
  imports = myLib.scanPaths ./.;
  programs.firefox.configPath = "${config.home.homeDirectory}/${profile}";

}
