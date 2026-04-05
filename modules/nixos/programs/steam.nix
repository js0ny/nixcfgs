{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.nixdots.programs.steam;
in
  lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send -u low -a 'GameMode' 'GameMode Started'";
          end = "${pkgs.libnotify}/bin/notify-send -u low -a 'GameMode' 'GameMode Ended'";
        };
      };
    };
  }
