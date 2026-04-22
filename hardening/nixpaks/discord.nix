# Refer:
# - Flatpak manifest docs:
#   - https://docs.flatpak.org/en/latest/manifests.html
#   - https://docs.flatpak.org/en/latest/sandbox-permissions.html
# - Discord flatpak manifest:
#   - https://github.com/flathub/com.discordapp.Discord/blob/master/com.discordapp.Discord.json
{
  lib,
  pkgs,
  mkNixPak,
  buildEnv,
  makeDesktopItem,
  ...
}:
let
  appId = "com.discordapp.Discord";
  socatBin = lib.getExe pkgs.socat;
  mkdirBin = lib.getExe' pkgs.coreutils "mkdir";
  dirnameBin = lib.getExe' pkgs.coreutils "dirname";
  rmBin = lib.getExe' pkgs.coreutils "rm";
  discordBin = lib.getExe pkgs.discord;
  discordRpcBridge = pkgs.writeShellScriptBin "discord-rpc-bridge" ''
    set -eu

    OUR_SOCKET="''${XDG_RUNTIME_DIR}/app/${appId}/discord-ipc-0"
    DISCORD_SOCKET="''${XDG_RUNTIME_DIR}/discord-ipc-0"

    ${mkdirBin} -p "$(${dirnameBin} "$OUR_SOCKET")"

    invoke_socat=true
    if [ -S "$OUR_SOCKET" ]; then
      if ${socatBin} -u OPEN:/dev/null "UNIX-CONNECT:$OUR_SOCKET" >/dev/null 2>&1; then
        invoke_socat=false
      else
        ${rmBin} -f "$OUR_SOCKET"
      fi
    fi

    socat_pid=""
    if [ "$invoke_socat" = true ]; then
      ${socatBin} "UNIX-LISTEN:$OUR_SOCKET,forever,fork" "UNIX-CONNECT:$DISCORD_SOCKET" &
      socat_pid=$!
    fi

    cleanup() {
      if [ -n "$socat_pid" ]; then
        kill -TERM "$socat_pid" >/dev/null 2>&1 || true
      fi
    }
    trap cleanup EXIT INT TERM

    ${discordBin} "$@"
  '';

  wrapped = mkNixPak {
    config =
      { sloth, ... }:
      {
        app = {
          package = buildEnv {
            name = "nixpak-discord";
            paths = [
              pkgs.discord
              pkgs.socat
              discordRpcBridge
            ];
          };
          binPath = "bin/discord-rpc-bridge";
        };
        flatpak.appId = appId;
        flatpakDataDir = false;
        xdgBind = {
          config = [
            "discord"
            "Vencord"
          ];
          data = [ "discord" ];
          cache = [ "discord" ];
        };

        imports = [
          ./modules/gui-base.nix
          ./modules/network.nix
          ./modules/common.nix
        ];

        dbus.policies = {
          "com.canonical.Unity" = "talk";
          "com.canonical.indicator.application" = "talk";
          "org.freedesktop.portal.Desktop" = "talk";
          "org.freedesktop.UPower" = "talk";
        };

        bubblewrap = {
          bind.rw = [
            [
              (sloth.concat' sloth.homeDir "/.sandbox/downloads")
              sloth.xdgDownloadDir
            ]
            [
              (sloth.mkdir (sloth.concat' sloth.runtimeDir "/app/${appId}"))
              (sloth.concat' sloth.runtimeDir "/app/${appId}")
            ]
            (sloth.concat' sloth.runtimeDir "/pipewire-0")
            (sloth.concat' sloth.runtimeDir "/speech-dispatcher")
          ];
          bind.ro = [
            sloth.xdgVideosDir
            sloth.xdgPicturesDir
            (sloth.envOr "XAUTHORITY" (sloth.concat' sloth.runtimeDir "/.Xauthority"))
          ];
          sockets = {
            x11 = true;
            wayland = true;
            pipewire = true;
          };
          env = {
            ELECTRON_TRASH = "gio";
            NIXOS_OZONE_WL = "1";
            ELECTRON_OZONE_PLATFORM_HINT = "auto";
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
      name = "Discord";
      desktopName = "Discord";
      genericName = "All-in-one cross-platform voice and text chat for gamers";
      exec = "${exePath} --enable-features=WebRTCPipeWireCapturer";
      terminal = false;
      icon = "discord";
      startupNotify = true;
      startupWMClass = "discord";
      type = "Application";
      categories = [
        "Network"
        "InstantMessaging"
      ];
      mimeTypes = [ "x-scheme-handler/discord" ];
      extraConfig = {
        Version = "1.5";
        X-Flatpak = appId;
      };
    })
  ];
}
