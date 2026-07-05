{
  pkgs,
  lib,
  config,
  ...
}:
let
  p = config.nixdots.programs.firefox.defaultProfile;
  id = "containerise@kinte.sh";
  pkg = pkgs.firefox-addons.containerise;
in
{
  imports = [ ./lib.nix ];

  options.programs.firefox.profiles = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        {
          name,
          config,
          ...
        }:
        {
          options.containerise = {
            enable = lib.mkEnableOption "Automatically open websites in a dedicated container. Simply add rules to map domain or subdomain to your container.";
            settings = lib.mkOption {
              type =
                with lib.types;
                attrsOf (
                  submodule (
                    { ... }:
                    {
                      options = {
                        containerId = lib.mkOption {
                          type = lib.types.int;
                          description = "The container ID to move matching sites to.";
                        };
                        patterns = lib.mkOption {
                          type = lib.types.listOf lib.types.str;
                          default = [ ];
                          description = "A list of URL patterns to match for moving sites to the specified container.";
                        };
                      };
                    }
                  )
                );
              default = { };
              example = { };
            };
          };

          config = lib.mkIf config.containerise.enable {
            extensions.packages = [ pkg ];
            extensionStorage."${id}".settings =
              let
                genAttrs = name: id: pattern: {
                  "map=${pattern}" = {
                    host = pattern;
                    containerName = name;
                    cookieStoreId = "firefox-container-${toString id}";
                    enabled = true;
                  };
                };
                genAttrsFromList =
                  name: id: patterns:
                  lib.foldl' (acc: pattern: acc // genAttrs name id pattern) { } patterns;
              in
              lib.foldl' lib.recursiveUpdate { } (
                lib.mapAttrsToList (
                  name: value: genAttrsFromList name value.containerId value.patterns
                ) config.containerise.settings
              );
          };
        }
      )
    );
  };
}
