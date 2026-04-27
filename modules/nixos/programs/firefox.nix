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
in
lib.mkIf cfg {
  programs.firefox = {
    enable = true;
    languagePacks = [ "zh-CN" ];
    preferences = baseprefs;
    policies = policies;
  };
}
