{
  pkgs,
  lib,
  config,
  ...
}:
let
  profile = config.nixdefs.consts.firefox.profileDir;
  persistDir = lib.removeSuffix "/firefox" profile;
  cfg = config.nixdots.programs.firefox;
  p = config.nixdots.programs.firefox.defaultProfile;
  policies = import ../../../../common/firefox-policies.nix;
  isNixOS = config.nixdots.linux.enable && config.nixdots.linux.nixos;
in
{
  imports = [
    ./betterfox.nix
    ./addons
    ./keymaps.nix
    ./search.nix
    ./styles.nix
    ./containers.nix
  ];
  # Upstream: https://github.com/nix-community/stylix/issues/2071
  stylix.targets.firefox = {
    profileNames = [ "${p}" ];
    enable = false;
  };

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

  # antidots
  home.file.".mozilla/native-messaging-hosts/.keep".enable = lib.mkForce false;

  nixdots.persist.home = lib.mkIf (cfg.enable) { directories = [ persistDir ]; };
  programs.firefox.policies = lib.mkIf pkgs.stdenv.isDarwin policies;
}
