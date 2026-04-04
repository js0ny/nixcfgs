{
  config,
  lib,
  pkgs,
  ...
}: {
  options.programs.firefox.profiles = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options.extensionStorage = lib.mkOption {
        description = "Generic local storage injection for Firefox extensions (Keyed by extension UUID).";
        default = {};
        type = lib.types.attrsOf (lib.types.submodule {
          options.settings = lib.mkOption {
            type = lib.types.attrs;
            default = {};
            description = "The configuration object to be injected into storage.js";
          };
        });
      };
    });
  };

  config.mergetools = lib.foldl' lib.recursiveUpdate {} (lib.mapAttrsToList (
      profileName: profileCfg: let
        basePath =
          if pkgs.stdenv.isDarwin
          then "${config.home.homeDirectory}/Library/Application Support/Firefox/Profiles/${profileName}"
          else "${config.home.homeDirectory}/.mozilla/firefox/${profileName}";
      in
        lib.mapAttrs' (
          uuid: extCfg:
            lib.nameValuePair "${profileName}-ext-${uuid}" {
              target = "${basePath}/browser-extension-data/${uuid}/storage.js";
              format = "json";
              settings = extCfg.settings;
            }
        )
        profileCfg.extensionStorage
    )
    config.programs.firefox.profiles);
}
