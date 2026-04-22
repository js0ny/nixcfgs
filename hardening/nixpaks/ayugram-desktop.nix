{
  lib,
  mkNixPak,
  buildEnv,
  makeDesktopItem,
  ayugram-desktop,
  ...
}:
let
  appId = "com.ayugram.desktop";

  wrapped = mkNixPak {
    config =
      { sloth, ... }:
      {
        app = {
          package = buildEnv {
            name = "nixpak-ayugram";
            paths = [ ayugram-desktop ];
          };
          binPath = "bin/AyuGram";
        };
        flatpak.appId = appId;
        flatpakDataDir = false;
        xdgBind = {
          data = [ "AyuGramDesktop" ];
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
      desktopName = "AyuGram Desktop";
      comment = "Desktop version of AyuGram - ToS breaking Telegram client";
      tryExec = "AyuGram";
      exec = "${exePath} -- %u";
      icon = "${ayugram-desktop}/share/icons/hicolor/512x512/apps/${appId}.png";
      startupNotify = true;
      startupWMClass = appId;
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
        "ayugram"
      ];
      actions = {
        quit = {
          name = "Quit AyuGram";
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
