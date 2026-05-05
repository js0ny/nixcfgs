# FIXME: Known issues
# * Filesystem interaction
# * Cannot call non-uv/bun-native mcps from stdio
{
  lib,
  pkgs,
  buildEnv,
  mkNixPak,
  makeDesktopItem,
  package ? pkgs.cherry-studio,
  dotDir ? ".cherrystudio",
  extraPkgs ? [ ],
  extraMnts ? [ ],
  ...
}:
let
  appId = "com.cherry_ai.CherryStudio";

  wrapped = mkNixPak {
    config =
      { sloth, ... }:
      {
        app = {
          package = buildEnv {
            name = "nixpak-cherry-studio";
            paths = [
              package
              pkgs.flatpak-xdg-utils
            ]
            ++ extraPkgs;
          };
          binPath = "bin/cherry-studio";
        };
        flatpak.appId = appId;
        flatpakDataDir = false;
        xdgBind = {
          config = [ "CherryStudio" ];
        };

        imports = [
          ./modules/gui-base.nix
          ./modules/network.nix
          ./modules/common.nix
        ];

        bubblewrap = {
          shareIpc = true;
          bind.rw = [
            [
              (sloth.concat' sloth.homeDir "/${dotDir}")
              (sloth.concat' sloth.homeDir "/.cherrystudio")
            ]
          ]
          ++ map (mnt: sloth.concat' sloth.homeDir "/${mnt}") extraMnts;
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
      desktopName = "Cherry Studio";
      genericName = "LLM Frontend";
      comment = "A powerful AI assistant for producer.";
      exec = "${exePath} --no-sandbox --ozone-platform-hint=auto %U";
      terminal = false;
      icon = "${pkgs.cherry-studio}/share/icons/cherry-studio.png";
      startupNotify = true;
      startupWMClass = "CherryStudio";
      type = "Application";
      categories = [
        "Utility"
      ];
      mimeTypes = [
        "x-scheme-handler/cherrystudio"
      ];
      extraConfig = {
        X-Flatpak = appId;
      };
    })
  ];
}
