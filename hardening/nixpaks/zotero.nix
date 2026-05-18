{
  lib,
  mkNixPak,
  buildEnv,
  makeDesktopItem,
  pkgs,
  package ? pkgs.zotero,
  dotDir ? ".zotero",
  libraryDir ? "Zotero",
  ...
}:
let
  appId = "org.zotero.Zotero";

  wrapped = mkNixPak {
    config =
      { sloth, ... }:
      {
        app.package = package;
        flatpak.appId = appId;
        flatpakDataDir = false;

        imports = [
          ./modules/gui-base.nix
          ./modules/network.nix
          ./modules/common.nix
        ];

        dbus = {
          enable = true;
          policies = {
            "org.mozilla.zotero.*" = "own";
          };
        };

        bubblewrap = {
          bind.rw = [
            [
              (sloth.concat' sloth.homeDir "/${dotDir}")
              (sloth.concat' sloth.homeDir "/.zotero")
            ]
            [
              (sloth.concat' sloth.homeDir "/${libraryDir}")
              (sloth.concat' sloth.homeDir "/Zotero")
            ]
          ];
          bind.ro = [
            (sloth.concat' sloth.runtimeDir "/speech-dispatcher")
          ];
          sockets = {
            x11 = true;
            wayland = true;
            pipewire = true;
          };
          env = {
            MOZ_APP_REMOTINGNAME = appId;
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
      desktopName = "Zotero";
      genericName = "Reference Management";
      comment = "Collect, organize, cite, and share your research sources";
      exec = "${exePath} -url %U";
      icon = "zotero";
      startupNotify = true;
      type = "Application";
      categories = [
        "Office"
        "Database"
      ];
      mimeTypes = [
        "x-scheme-handler/zotero"
        "text/plain"
      ];
      extraConfig = {
        X-Flatpak = appId;
        Version = "1.5";
      };
    })
  ];
}
