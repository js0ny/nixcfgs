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
            name = "nixpak-qq";
            paths = [
              ticktick
              # pkgs.fcitx5-gtk
              # pkgs.kdePackages.fcitx5-qt
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
            # LD_LIBRARY_PATH = "${pkgs.libx11}/lib:${pkgs.libxcb}/lib:${pkgs.krb5.lib}/lib:${pkgs.libgssglue}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.fcitx5-gtk}/lib:${pkgs.kdePackages.fcitx5-qt}/lib";
            NIXOS_OZONE_WL = "1";
            # XAUTHORITY = sloth.envOr "XAUTHORITY" (sloth.concat' sloth.runtimeDir "/.Xauthority");
            # QT_QPA_PLATFORM = "xcb";
            # ELECTRON_OZONE_PLATFORM_HINT = "x11";
            # QT_PLUGIN_PATH = "${pkgs.kdePackages.fcitx5-qt}/lib/qt-6/plugins";
            # GTK_PATH = "${pkgs.fcitx5-gtk}/lib/gtk-3.0";
            # GTK_IM_MODULE = "fcitx";
            # QT_IM_MODULE = "fcitx";
            # SDL_IM_MODULE = "fcitx";
            # XMODIFIERS = "@im=fcitx";
            # INPUT_METHOD = "fcitx";
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
      exec = "${exePath} %U";
      terminal = false;
      icon = "${ticktick}/share/icons/hicolor/512x512/apps/qq.png";
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
