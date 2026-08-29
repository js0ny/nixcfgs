{
  config,
  lib,
  ...
}:
let
  modules = config.flake;
  myLib = import ../../lib { inherit lib; };
in
{
  imports = myLib.scanPaths ./sessions ++ [ ./wm-components ];

  flake.nixosModules.desktop =
    { myLib, pkgs, ... }:
    {
      imports = [
        modules.nixosModules.chromium
        modules.nixosModules.core
        modules.nixosModules.dolphin
        modules.nixosModules.firefox
        modules.nixosModules.fish
        modules.nixosModules.modern-unix
        modules.nixosModules.nix-index-database
        modules.nixosModules.obs-studio
        modules.nixosModules.rime
        modules.nixosModules.social-tencent
        modules.nixosModules.steam
        modules.nixosModules.thunderbird
        modules.nixosModules.vicinae
      ]
      ++ myLib.scanFiles ./nixos;

      nixdefs.hardware.enable = true;
      programs.appimage = {
        enable = true;
        package = pkgs.appimage-run.override {
          extraPkgs = pkgs: [ pkgs.zstd ];
        };
      };
    };

  flake.homeModules.desktop = { myLib, ... }: {
    imports = [
      modules.homeModules.chromium
      modules.homeModules.dolphin
      modules.homeModules.firefox
      modules.homeModules.fish
      modules.homeModules.mcp
      modules.homeModules.modern-unix
      modules.homeModules.nushell
      modules.homeModules.obs-studio
      modules.homeModules.okular
      modules.homeModules.pcloud
      modules.homeModules.proton-pass
      modules.homeModules.protonvpn
      modules.homeModules.rime
      modules.homeModules.rtorrent
      modules.homeModules.sdcv
      modules.homeModules.steam
      modules.homeModules.swayimg
      modules.homeModules.thunderbird
      modules.homeModules.vicinae
    ]
    ++ myLib.scanFiles ./home;
  };
}
