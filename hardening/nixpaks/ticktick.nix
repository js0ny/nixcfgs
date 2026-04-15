# Refer:
# - Flatpak manifest's docs:
#   - https://docs.flatpak.org/en/latest/manifests.html
#   - https://docs.flatpak.org/en/latest/sandbox-permissions.html
# - QQ's flatpak manifest: https://github.com/flathub/com.qq.QQ/blob/master/com.qq.QQ.yaml
{
  lib,
  ticktick,
  pkgs,
  mkNixPak,
  buildEnv,
  makeDesktopItem,
  ...
}:
let
  appId = "com.ticktick.TickTick";

  wrapped = mkNixPak {
    config =
      { sloth, ... }:
      {
        app = {
          package = buildEnv {
            name = "nixpak-ticktick";
            paths = [
              ticktick
            ];
          };
          binPath = "bin/ticktick";
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
          ];
          bind.ro = [
            "${pkgs.libx11}/lib"
            "${pkgs.libxcb}/lib"
            "${pkgs.krb5.lib}/lib"
            "${pkgs.stdenv.cc.cc.lib}/lib"
            (sloth.concat' sloth.xdgPicturesDir "/Screenshots")
          ];
          sockets = {
            x11 = false;
            wayland = true;
            pipewire = true;
          };
          env = {
            NIXOS_OZONE_WL = "1";
            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
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
      desktopName = "TickTick";
      genericName = "Task Management";
      comment = "TickTick is a powerful to-do & task management app with seamless cloud synchronization across all your devices. Whether you need to schedule an agenda, make memos, share shopping lists, collaborate in a team, or even develop a new habit, TickTick is always here to help you get stuff done and keep life on track.";
      exec = "${exePath} --ozone-platform-hint=wayland --enable-wayland-ime %U";
      terminal = false;
      icon = "ticktick";
      startupNotify = true;
      startupWMClass = "ticktick";
      type = "Application";
      categories = [
        "Office"
      ];
      extraConfig = {
        X-Flatpak = appId;
      };
    })
  ];
}
