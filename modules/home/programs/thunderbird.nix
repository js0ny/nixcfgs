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
in
lib.mkIf cfg.enable {
  programs.thunderbird = {
    enable = true;
    profiles."${profile}" = {
      isDefault = true;
      settings = {
        "mailnews.message_display.disable_remote_image" = false;
      };
      extensions = with nur-addons; [ tbkeys ];
    };
  };
  catppuccin.thunderbird.profile = profile;
  nixdots.persist.home = {
    directories = [
      ".thunderbird"
    ];
  };
  home.packages = with pkgs; [
    birdtray
  ];
}
