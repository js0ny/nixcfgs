# Refer: https://github.com/flathub/org.jeffvli.feishin/blob/master/org.jeffvli.feishin.yml
{
  lib,
  pkgs,
  mkNixPak,
  buildEnv,
  makeDesktopItem,
  ...
}:
let
  appId = "org.jeffvli.feishin";

  wrapped = mkNixPak {
    config =
      { sloth, ... }:
      {
        app = {
          package = buildEnv {
            name = "nixpak-feishin";
            paths = [ pkgs.feishin ];
          };
          binPath = "bin/feishin";
        };
        flatpak.appId = appId;
        flatpakDataDir = false;
        xdgBind = {
          config = [ "feishin" ];
        };

        imports = [
          ./modules/gui-base.nix
          ./modules/network.nix
          ./modules/common.nix
        ];

        dbus.policies = {
          "org.kde.StatusNotifierWatcher" = "talk";
          "org.mpris.MediaPlayer2.Feishin" = "own";
          "org.freedesktop.secrets" = "talk";
          "org.kde.kwalletd5" = "talk";
        };

        bubblewrap = {
          bind.rw = [
            [
              (sloth.mkdir (sloth.concat' sloth.runtimeDir "/app/${appId}"))
              (sloth.concat' sloth.runtimeDir "/app/${appId}")
            ]
          ];
          bind.ro = [
            (sloth.concat' sloth.runtimeDir "/app/com.discordapp.Discord")
          ];
          sockets = {
            x11 = false;
            wayland = true;
            pipewire = true;
          };
          env = {
            XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
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
      desktopName = "Feishin";
      genericName = "Music Player";
      comment = "Desktop client for Jellyfin and Subsonic music servers";
      exec = "${exePath} %U";
      terminal = false;
      icon = "${pkgs.feishin}/share/icons/hicolor/512x512/apps/feishin.png";
      startupNotify = true;
      startupWMClass = "feishin";
      type = "Application";
      categories = [
        "Audio"
        "Music"
        "AudioVideo"
      ];
      mimeTypes = [ "x-scheme-handler/feishin" ];
      extraConfig = {
        X-Flatpak = appId;
      };
    })
  ];
}
