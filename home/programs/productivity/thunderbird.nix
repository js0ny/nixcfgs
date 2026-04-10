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
    };
  };
  catppuccin.thunderbird.profile = profile;
  nixdots.persist.home = {
    directories = [
      ".thunderbird/${profile}"
    ];
  };
  home.packages = with pkgs; [
    birdtray
  ];
}
