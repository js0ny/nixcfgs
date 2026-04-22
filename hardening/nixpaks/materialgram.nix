# https://raw.githubusercontent.com/flathub/io.github.kukuruzka165.materialgram/refs/heads/master/io.github.kukuruzka165.materialgram.yml
{
  lib,
  materialgram,
  mkNixPak,
  buildEnv,
  makeDesktopItem,
  ...
}:
let
  appId = "io.github.kukuruzka165.materialgram";

  wrapped = mkNixPak {
    config =
      { sloth, ... }:
      {
        app = {
          package = buildEnv {
            name = "materialgram";
            paths = [ materialgram ];
          };
          binPath = "bin/materialgram";
        };
        flatpak.appId = appId;
        flatpakDataDir = false;
        xdgBind = {
          data = [ "materialgram" ];
        };

        imports = [
          ./modules/gui-base.nix
          ./modules/network.nix
          ./modules/common.nix
        ];

        dbus = {
          enable = true;
          policies = {
            "com.canonical.indicator.application" = "talk";
            "org.ayatana.indicator.application" = "talk";
            "org.gnome.Mutter.IdleMonitor" = "talk";
            "org.sigxcpu.Feedback" = "talk";
          };
        };

        bubblewrap = {
          bind.rw = [
            sloth.xdgDownloadDir
          ];
          sockets = {
            x11 = true;
            wayland = true;
            pipewire = true;
          };
          env = {
            QT_PLUGIN_PATH = "";
            QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
            GTK_USE_PORTAL = "1";
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
      desktopName = "materialgram";
      comment = "Unofficial Telegram Desktop with Material Design";
      tryExec = "materialgram";
      exec = "${exePath} -- %u";
      icon = "${materialgram}/share/icons/hicolor/512x512/apps/${appId}.png";
      startupNotify = true;
      startupWMClass = "materialgram";
      terminal = false;
      type = "Application";
      categories = [
        "Chat"
        "Network"
        "InstantMessaging"
        "Qt"
      ];
      mimeTypes = [
        "x-scheme-handler/tg"
        "x-scheme-handler/tonsite"
      ];
      keywords = [
        "tg"
        "chat"
        "im"
        "messaging"
        "messenger"
        "sms"
        "tdesktop"
        "telegram"
        "materialgram"
      ];
      actions = {
        quit = {
          name = "Quit materialgram";
          exec = "${exePath} -quit";
          icon = "application-exit";
        };
      };
      extraConfig = {
        X-Flatpak = appId;
        SingleMainWindow = "true";
        X-GNOME-UsesNotifications = "true";
        X-GNOME-SingleWindow = "true";
      };
    })
  ];
}
