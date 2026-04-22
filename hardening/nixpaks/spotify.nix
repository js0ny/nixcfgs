# NOTE: Untested
{
  lib,
  pkgs,
  mkNixPak,
  buildEnv,
  makeDesktopItem,
  extraModules ? [ ],
  ...
}:
let
  appId = "com.spotify.Client";

  wrapped = mkNixPak {
    config =
      { sloth, ... }:
      {
        app = {
          package = buildEnv {
            name = "nixpak-spotify";
            paths = with pkgs; [
              spotify
            ];
          };
          binPath = "bin/spotify";
        };
        flatpak.appId = appId;
        flatpakDataDir = true;

        imports = [
          ./modules/gui-base.nix
          ./modules/network.nix
          ./modules/common.nix
        ]
        ++ extraModules;

        dbus.policies = {
          "org.freedesktop.ScreenSaver" = "talk";
          "org.freedesktop.systemd1" = "see";
          "org.gnome.SettingsDaemon.MediaKeys" = "talk";
          "org.gtk.vfs.Daemon" = "talk";
          "org.kde.kwalletd6" = "talk";
          "org.mpris.MediaPlayer2.spotify" = "own";
        };

        bubblewrap = {
          bind.rw = [
            [
              (sloth.concat' sloth.homeDir "/.sandbox/downloads")
              sloth.xdgDownloadDir
            ]
          ];
          bind.ro = [
          ];
          sockets = {
            x11 = false;
            wayland = true;
            pipewire = true;
          };
          env = {
          };
        };

        pasta = {
          enable = true;
          mode = "isolate";
          args = [
            "--outbound-if4"
            "wg-jp"
            "--dns"
            "10.2.0.1"
          ];
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
      desktopName = "Spotify";
      genericName = "Music Player";
      comment = "";
      exec = "${exePath} --ozone-platform-hint=auto %U";
      terminal = false;
      icon = "${pkgs.spotify}/share/icons/hicolor/512x512/apps/spotify-client.png";
      startupNotify = true;
      startupWMClass = "spotify";
      type = "Application";
      categories = [
        "Audio"
        "Music"
        "Player"
        "AudioVideo"
      ];
      mimeTypes = [ "x-scheme-handler/spotify" ];
      extraConfig = {
        X-Flatpak = appId;
      };
    })
  ];
}
