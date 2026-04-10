{
  lib,
  pkgs,
  mkNixPak,
  buildEnv,
  makeDesktopItem,
  ...
}:
let
  appId = "com.terminus.Termius";

  wrapped = mkNixPak {
    config =
      { sloth, ... }:
      {
        app = {
          package = buildEnv {
            name = "nixpak-termius";
            paths = with pkgs; [
              termius
              libglvnd
              mesa
              stdenv.cc.cc.lib
            ];
          };
          binPath = "bin/termius-app";
        };
        flatpak.appId = appId;

        imports = [
          ./modules/gui-base.nix
          ./modules/network.nix
          ./modules/common.nix
        ];

        bubblewrap = {
          bind.rw = [
            [
              (sloth.concat' sloth.homeDir "/.sandbox/downloads")
              sloth.xdgDownloadDir
            ]
            [
              (sloth.concat' sloth.homeDir "/.sandbox/exchange")
              (sloth.concat' sloth.homeDir "/Shared")
            ]
            (sloth.concat' sloth.homeDir "/Public")
          ];
          bind.ro = [
            "${pkgs.libglvnd}/lib"
            "${pkgs.mesa}/lib"
            "${pkgs.stdenv.cc.cc.lib}/lib"
            "/etc/passwd"
            "/etc/group"
            "/etc/nsswitch.conf"
          ];
          sockets = {
            x11 = false;
            wayland = true;
            pipewire = true;
          };
          env = {
            LD_LIBRARY_PATH = "${pkgs.libglvnd}/lib:${pkgs.mesa}/lib:${pkgs.stdenv.cc.cc.lib}/lib";
            LIBGL_DRIVERS_PATH = "${pkgs.mesa}/lib/dri";
          };
        };
      };
  };
  exePath = lib.getExe wrapped.config.script;
in
buildEnv {
  inherit (wrapped.config.script) name meta passthru;
  paths = [
    wrapped.config.script
    (makeDesktopItem {
      name = appId;
      desktopName = "Termius";
      genericName = "Cross-platform SSH client";
      comment = "The SSH client that works on Desktop and Mobile";
      exec = "${exePath} --ozone-platform-hint=auto %U";
      terminal = false;
      icon = "${pkgs.termius}/share/icons/hicolor/1024x1024/termius-app.png";
      startupNotify = true;
      startupWMClass = "Termius";
      type = "Application";
      categories = [
        "Network"
      ];
      extraConfig = {
        X-Flatpak = appId;
      };
    })
  ];
}
