# FIXME: No sound.
# Refer: https://github.com/flathub/org.jeffvli.feishin/blob/master/org.jeffvli.feishin.yml
{
  lib,
  mkNixPak,
  buildEnv,
  makeDesktopItem,
  pkgs,
  ...
}:
let
  appId = "sh.cider.genten";

  wrapped = mkNixPak {
    config =
      { sloth, ... }:
      {
        app = {
          package = buildEnv {
            name = "nixpak-cider-2";
            paths = (pkgs.mkElectronWayland [ pkgs.cider-2 ]);
          };
          binPath = "bin/cider-2";
        };
        flatpak.appId = appId;
        flatpakDataDir = false;
        xdgBind = {
          config = [ "sh.cider.genten" ];
        };

        imports = [
          ./modules/gui-base.nix
          ./modules/network.nix
          ./modules/common.nix
        ];

        dbus.policies = {
          "org.kde.StatusNotifierWatcher" = "talk";
          "org.mpris.MediaPlayer2.cider" = "own";
          "org.freedesktop.secrets" = "talk";
          "org.kde.kwalletd5" = "talk";
        };

        bubblewrap = {
          bind.ro = [
            (sloth.concat' sloth.runtimeDir "/app/com.discordapp.Discord")
          ];
          sockets = {
            x11 = false;
            wayland = true;
            pipewire = true;
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
      desktopName = "Cider";
      genericName = "Music Player";
      comment = "A cross-platform Apple Music experience built on Vue.js and written from the ground up with performance in mind.";
      exec = "${exePath} %U";
      terminal = false;
      icon = "cider";
      startupNotify = true;
      startupWMClass = "Cider";
      type = "Application";
      categories = [
        "Audio"
        "Music"
        "AudioVideo"
      ];
      mimeTypes = [
        "x-scheme-handler/cider"
        "x-scheme-handler/itms"
        "x-scheme-handler/itmss"
        "x-scheme-handler/music"
        "x-scheme-handler/itunes"
      ];
      actions = {
        PlayPause = {
          name = "Play-Pause";
          exec = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.cider /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause";
        };
        Next = {
          name = "Next";
          exec = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.cider /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next";
        };
        Previous = {
          name = "Previous";
          exec = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.cider /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous";
        };
        Stop = {
          name = "Stop";
          exec = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.cider /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop";
        };
      };
      extraConfig = {
        X-Flatpak = appId;
      };
    })
  ];
}
