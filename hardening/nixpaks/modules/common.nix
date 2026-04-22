# https://github.com/mnixry/nixos-config/blob/74913c2b90d06e31170bbbaa0074f915721da224/desktop/packages/nixpaks-common.nix
# https://github.com/Kraftland/portable/blob/09c4a4227538a3f42de208a6ecbdc938ac9c00dd/portable.sh
# https://flatpak.github.io/xdg-desktop-portal/docs/api-reference.html
{
  lib,
  sloth,
  config,
  ...
}:
let
  inherit (config.flatpak) appId;
in
{
  options = {
    flatpakDataDir = lib.mkEnableOption "Flatpak-style ~/.var/app data directory isolation";

    xdgBind = lib.mkOption {
      type = lib.types.submodule {
        options = {
          data = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Subdirectory names to bind-mount from XDG_DATA_HOME (effective when flatpakDataDir is disabled)";
          };
          config = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Subdirectory names to bind-mount from XDG_CONFIG_HOME (effective when flatpakDataDir is disabled)";
          };
          cache = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Subdirectory names to bind-mount from XDG_CACHE_HOME (effective when flatpakDataDir is disabled)";
          };
        };
      };
      default = {};
    };
  };

  config = {
    dbus = {
      policies =
        {
          "${appId}" = "own";
          "${appId}.*" = "own";
          "org.freedesktop.DBus" = "talk";
          "ca.desrt.dconf" = "talk";
          "org.freedesktop.appearance" = "talk";
          "org.freedesktop.appearance.*" = "talk";
        }
        // (builtins.listToAttrs (
          map (id: lib.nameValuePair "org.kde.StatusNotifierItem-${toString id}-1" "own") (
            lib.lists.range 2 29
          )
        ))
        // {
          "org.mpris.MediaPlayer2.${appId}" = "own";
          "org.mpris.MediaPlayer2.${appId}.*" = "own";
          "org.mpris.MediaPlayer2.${lib.lists.last (lib.strings.splitString "." appId)}" = "own";
          "org.mpris.MediaPlayer2.${lib.lists.last (lib.strings.splitString "." appId)}.*" = "own";

          "com.canonical.AppMenu.Registrar" = "talk";
          "org.freedesktop.FileManager1" = "talk";
          "org.freedesktop.Notifications" = "talk";
          "org.kde.StatusNotifierWatcher" = "talk";
          "org.gnome.Shell.Screencast" = "talk";

          "org.a11y.Bus" = "see";

          "org.freedesktop.portal.Documents" = "talk";
          "org.freedesktop.portal.FileTransfer" = "talk";
          "org.freedesktop.portal.FileTransfer.*" = "talk";
          "org.freedesktop.portal.Notification" = "talk";
          "org.freedesktop.portal.OpenURI" = "talk";
          "org.freedesktop.portal.OpenURI.OpenFile" = "talk";
          "org.freedesktop.portal.OpenURI.OpenURI" = "talk";
          "org.freedesktop.portal.Print" = "talk";
          "org.freedesktop.portal.Request" = "see";

          "org.freedesktop.portal.Fcitx" = "talk";
          "org.freedesktop.portal.Fcitx.*" = "talk";
          "org.freedesktop.portal.IBus" = "talk";
          "org.freedesktop.portal.IBus.*" = "talk";
        };
      rules.call = {
        "org.a11y.Bus" = [
          "org.a11y.Bus.GetAddress@/org/a11y/bus"
          "org.freedesktop.DBus.Properties.Get@/org/a11y/bus"
        ];

        "org.freedesktop.FileManager1" = [ "*" ];
        "org.freedesktop.Notifications.*" = [ "*" ];
        "org.freedesktop.portal.Documents" = [ "*" ];
        "org.freedesktop.portal.FileTransfer" = [ "*" ];
        "org.freedesktop.portal.FileTransfer.*" = [ "*" ];
        "org.freedesktop.portal.Fcitx" = [ "*" ];
        "org.freedesktop.portal.Fcitx.*" = [ "*" ];
        "org.freedesktop.portal.IBus" = [ "*" ];
        "org.freedesktop.portal.IBus.*" = [ "*" ];
        "org.freedesktop.portal.Notification" = [ "*" ];
        "org.freedesktop.portal.OpenURI" = [ "*" ];
        "org.freedesktop.portal.OpenURI.OpenFile" = [ "*" ];
        "org.freedesktop.portal.OpenURI.OpenURI" = [ "*" ];
        "org.freedesktop.portal.Print" = [ "*" ];
        "org.freedesktop.portal.Request" = [ "*" ];

        "org.freedesktop.portal.Desktop" = [
          "org.freedesktop.DBus.Properties.GetAll"
          "org.freedesktop.DBus.Properties.Get@/org/freedesktop/portal/desktop"
          "org.freedesktop.portal.Session.Close"
          "org.freedesktop.portal.Settings.ReadAll"
          "org.freedesktop.portal.Settings.Read"
          "org.freedesktop.portal.Account.GetUserInformation"

          "org.freedesktop.portal.NetworkMonitor"
          "org.freedesktop.portal.NetworkMonitor.*"
          "org.freedesktop.portal.ProxyResolver.Lookup"
          "org.freedesktop.portal.ProxyResolver.Lookup.*"

          "org.freedesktop.portal.ScreenCast"
          "org.freedesktop.portal.ScreenCast.*"
          "org.freedesktop.portal.Screenshot"
          "org.freedesktop.portal.Screenshot.Screenshot"

          "org.freedesktop.portal.Camera"
          "org.freedesktop.portal.Camera.*"
          "org.freedesktop.portal.Usb"
          "org.freedesktop.portal.Usb.*"

          "org.freedesktop.portal.RemoteDesktop"
          "org.freedesktop.portal.RemoteDesktop.*"

          "org.freedesktop.portal.Documents"
          "org.freedesktop.portal.Documents.*"
          "org.freedesktop.portal.FileChooser"
          "org.freedesktop.portal.FileChooser.*"
          "org.freedesktop.portal.FileTransfer"
          "org.freedesktop.portal.FileTransfer.*"

          "org.freedesktop.portal.Notification"
          "org.freedesktop.portal.Notification.*"
          "org.freedesktop.portal.Print"
          "org.freedesktop.portal.Print.*"

          "org.freedesktop.portal.OpenURI"
          "org.freedesktop.portal.OpenURI.*"
          "org.freedesktop.portal.Email.ComposeEmail"

          "org.freedesktop.portal.Fcitx"
          "org.freedesktop.portal.Fcitx.*"
          "org.freedesktop.portal.IBus"
          "org.freedesktop.portal.IBus.*"

          "org.freedesktop.portal.Secret"
          "org.freedesktop.portal.Secret.RetrieveSecret"

          "org.freedesktop.portal.Inhibit"
          "org.freedesktop.portal.Inhibit.*"

          "org.freedesktop.portal.Request"
        ];
      };

      rules.broadcast = {
        "org.freedesktop.portal.*" = [ "@/org/freedesktop/portal/*" ];
      };
      args = [
        "--filter"
        "--sloppy-names"
        "--log"
      ];
    };

    etc.sslCertificates.enable = true;
    bubblewrap = {
      network = lib.mkDefault true;
      sockets = {
        wayland = true;
        pulse = true;
      };

      bind.rw =
        (lib.optionals config.flatpakDataDir [
          [ (sloth.mkdir sloth.appDataDir) sloth.xdgDataHome ]
          [ (sloth.mkdir sloth.appConfigDir) sloth.xdgConfigHome ]
          [ (sloth.mkdir sloth.appCacheDir) sloth.xdgCacheHome ]
        ])
        ++ (lib.optionals (!config.flatpakDataDir) (
          (map (dir: [
            (sloth.mkdir (sloth.concat' sloth.xdgDataHome "/${dir}"))
            (sloth.concat' sloth.xdgDataHome "/${dir}")
          ]) config.xdgBind.data)
          ++ (map (dir: [
            (sloth.mkdir (sloth.concat' sloth.xdgConfigHome "/${dir}"))
            (sloth.concat' sloth.xdgConfigHome "/${dir}")
          ]) config.xdgBind.config)
          ++ (map (dir: [
            (sloth.mkdir (sloth.concat' sloth.xdgCacheHome "/${dir}"))
            (sloth.concat' sloth.xdgCacheHome "/${dir}")
          ]) config.xdgBind.cache)
        ))
        ++ [
          (sloth.concat [
            sloth.runtimeDir
            "/"
            (sloth.envOr "WAYLAND_DISPLAY" "no")
          ])
          (sloth.concat' sloth.runtimeDir "/at-spi/bus")
          (sloth.concat' sloth.runtimeDir "/gvfsd")
          (sloth.concat' sloth.runtimeDir "/dconf")

          (sloth.concat' sloth.xdgCacheHome "/fontconfig")
          (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache")
          (sloth.concat' sloth.xdgCacheHome "/mesa_shader_cache_db")
          (sloth.concat' sloth.xdgCacheHome "/radv_builtin_shaders")
        ];
      bind.ro = [
        (sloth.concat' sloth.runtimeDir "/doc")
        (sloth.concat' sloth.xdgConfigHome "/kdeglobals")
        (sloth.concat' sloth.xdgConfigHome "/gtk-2.0")
        (sloth.concat' sloth.xdgConfigHome "/gtk-3.0")
        (sloth.concat' sloth.xdgConfigHome "/gtk-4.0")
        (sloth.concat' sloth.xdgConfigHome "/fontconfig")
        (sloth.concat' sloth.xdgConfigHome "/dconf")
      ];
      bind.dev = [ "/dev/shm" ] ++ (map (id: "/dev/video${toString id}") (lib.lists.range 0 9));
    };
  };
}
