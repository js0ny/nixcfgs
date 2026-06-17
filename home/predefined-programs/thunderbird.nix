{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.programs.thunderbird;
  profile = config.nixdots.user.name;
  nur-addons = pkgs.nur.repos.rycee.thunderbird-addons;
  isNixOS = config.nixdots.linux.enable && config.nixdots.linux.nixos;
in
lib.mkIf cfg.enable {
  programs.thunderbird = {
    enable = true;
    package = if isNixOS then pkgs.nixpaks.thunderbird else pkgs.thunderbird;
    profiles."${profile}" = {
      isDefault = true;
      settings = {
        "mailnews.message_display.disable_remote_image" = false;
      };
      extensions = with nur-addons; [ tbkeys ];
    };
  };
  nixdots.persist.home = {
    directories = [
      ".thunderbird"
    ];
  };
  home.packages = lib.optionals (pkgs.stdenv.isLinux) [ pkgs.birdtray ];
}
