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

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    fontPackages = with pkgs; [
      # source-han-sans
      wqy_zenhei
    ];
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
