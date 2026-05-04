{
  pkgs,
  config,
  lib,
  ...
}:
let
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
        start = "${lib.getExe pkgs.libnotify} -u low -a 'GameMode' 'GameMode Started'";
        end = "${lib.getExe pkgs.libnotify} -u low -a 'GameMode' 'GameMode Ended'";
      };
    };
  };
}
