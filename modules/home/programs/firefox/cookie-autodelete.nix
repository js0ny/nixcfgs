{
  config,
  lib,
  pkgs,
  ...
}: let
  id = "CookieAutoDelete@kennydo.com";
  pkg = pkgs.firefox-addons.cookie-autodelete;
in {
  imports = [
    ./lib.nix
  ];

  options.programs.firefox.profiles = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({
      name,
      config,
      ...
    }: {
      options.cookie-autodelete = {
        enable = lib.mkEnableOption "Cookie AutoDelete extension configuration";

        active = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable Active Mode (Auto-clean on tab close).";
        };

        allowList = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "A list of expressions to keep cookies for (Whitelist).";
        };

        denyList = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [];
          description = "A list of expressions to keep cookies until browser restart (Greylist).";
        };

        delayBeforeClean = lib.mkOption {
          type = lib.types.int;
          default = 15;
          description = "Delay in seconds before cleaning up cookies.";
        };

        cleanLocalStorage = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable LocalStorage cleanup.";
        };

        enableContainers = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable support for Firefox Contextual Identities (Containers).";
        };

        showNotifications = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Show notification after cleanup.";
        };
      };

      config = lib.mkIf config.cookie-autodelete.enable {
        extensions.packages = [pkg];

        extensionStorage."${id}".settings = {
          state = builtins.toJSON {
            lists = {
              # 使用 ++ 将白名单和灰名单的映射结果合并为一个列表
              default =
                (map (expr: {
                    expression = expr;
                    listType = "WHITE";
                    storeId = "default";
                    cleanSiteData = [];
                    cookieNames = [];
                    id = builtins.substring 0 9 (builtins.hashString "sha256" "WHITE-${expr}");
                  })
                  config.cookie-autodelete.allowList)
                ++ (map (expr: {
                    expression = expr;
                    listType = "GREY";
                    storeId = "default";
                    cleanSiteData = [];
                    cookieNames = [];
                    id = builtins.substring 0 9 (builtins.hashString "sha256" "GREY-${expr}");
                  })
                  config.cookie-autodelete.denyList);
            };
            settings = {
              activeMode = {
                name = "activeMode";
                value = config.cookie-autodelete.active;
              };
              delayBeforeClean = {
                name = "delayBeforeClean";
                value = config.cookie-autodelete.delayBeforeClean;
              };
              localStorageCleanup = {
                name = "localStorageCleanup";
                value = config.cookie-autodelete.cleanLocalStorage;
              };
              contextualIdentities = {
                name = "contextualIdentities";
                value = config.cookie-autodelete.enableContainers;
              };
              showNotificationAfterCleanup = {
                name = "showNotificationAfterCleanup";
                value = config.cookie-autodelete.showNotifications;
              };

              enableNewVersionPopup = {
                name = "enableNewVersionPopup";
                value = false;
              };
              statLogging = {
                name = "statLogging";
                value = false;
              };
            };
          };
        };
      };
    }));
  };
}
