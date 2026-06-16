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
  persistDir = lib.removeSuffix "/firefox" profile;
  cfg = config.nixdots.programs.firefox;
  p = config.nixdots.programs.firefox.defaultProfile;
  policies = import ../../../common/firefox-policies.nix;
  isNixOS = config.nixdots.linux.nixos;
in
{
  imports = myLib.scanPaths ./.;
  programs.firefox.configPath = "${config.home.homeDirectory}/${profile}";

  programs.firefox = {
    enable = cfg.enable;
    package =
      if isNixOS then
        pkgs.nixpaks.firefox
      else if pkgs.stdenv.isDarwin then
        pkgs.firefox-bin
      else
        pkgs.firefox;
  };

  nixdots.persist.home = lib.mkIf (cfg.enable) { directories = [ persistDir ]; };
  programs.firefox.policies = lib.mkIf pkgs.stdenv.isDarwin policies;
}
