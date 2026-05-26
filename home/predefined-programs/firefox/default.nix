# Run nightly:
# nix run "github:nix-community/flake-firefox-nightly#firefox-nightly-bin"
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
  policies = import ../../../common/firefox-policies.nix;
in
{
  imports = [
    ./cookie-autodelete.nix
    ./surfingkeys.nix
    ./userjs.nix
  ];
  programs.firefox.configPath = "${config.home.homeDirectory}/${profile}";

  programs.firefox = {
    enable = cfg.enable;
  };

  nixdots.persist.home =
    if cfg.enable then
      {
        directories = [
          persistDir
        ];
      }
    else
      { };
  programs.firefox.policies = lib.mkIf pkgs.stdenv.isDarwin policies;
}
