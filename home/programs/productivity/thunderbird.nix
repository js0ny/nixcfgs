{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.programs.thunderbird.enable;
  profile = config.nixdots.user.name;
in
{
  programs.thunderbird = {
    enable = true;
    profiles."${profile}" = {
      isDefault = true;
      settings = {
        "mailnews.message_display.disable_remote_image" = false;
      };
      extensions = with pkgs.nur.repos.rycee.thunderbird-addons; [
        tbkeys
      ];
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
  # Track prefs.js change
  home.file.".thunderbird/${profile}/.gitignore".text = ''
    *
    !*.js
  '';
}
