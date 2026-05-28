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

  # Upstream: https://github.com/NixOS/nixpkgs/issues/523427
  # https://github.com/NixOS/nixpkgs/pull/524488
  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    fontPackages = with pkgs; [ source-han-sans ];
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
