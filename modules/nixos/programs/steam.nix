{
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
  }
