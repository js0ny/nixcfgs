{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.programs.firefox.enable;
  policies = import ../../common/firefox-policies.nix;
  baseprefs = import ../../common/firefox-baseprefs.nix;
  wsl = config.nixdots.linux.wsl;
in
lib.mkIf (cfg && !wsl) {
  programs.firefox = {
    enable = true;
    languagePacks = [ config.nixdots.core.locales.guiLocale ];
    preferences = baseprefs;
    policies = policies;
  };
}
