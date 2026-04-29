{ lib, config, ... }:
let
  firefox = config.nixdefs.consts.firefox.profileDir;
  fxProfile = config.nixdots.programs.firefox.defaultProfile;
  selfhosted = config.nixdefs.selfhosted;
in
{
  # TODO: Declare plugin installation here
  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      # target = "niri.service";
      autoStart = true;
    };
    settings = {
      telemetry = {
        system_info = false;
      };
      consider_preedit = false;
      close_on_focus_loss = true;
      providers = {
        "@Ninetonne/store.vicinae.searxng" = {
          preferences = {
            "default_category" = "general";
            "details_start_open" = false;
            "keep_previous_search" = true;
            "languages" = "zh-CN";
          };
          entrypoints.search-with-searxng.alias = "sx";
        };
        "@knoopx/store.vicinae.firefox" = {
          preferences = {
            profile_dir = "${firefox}/${fxProfile}";
          };
        };
        clipboard.entrypoints = {
          history.alias = "cliphist";
        };
        system.entrypoints.run.alias = ">";
        "@knoopx/store.vicinae.nix".entrypoints = {
          home-manager-options.alias = "hm";
          options.alias = "opts";
          packages.alias = "pkgs";
        };
      }
      // (lib.optionalAttrs selfhosted.searxng.enable {
        "@Ninetonine/store.vicinae.searxng" = {
          preferences = {
            instance_domain = selfhosted.searxng.url;
            default_category = lib.mkDefault "general";
            details_start_open = lib.mkDefault false;
            keep_previous_search = lib.mkDefault true;
            languages = lib.mkDefault "en";
          };
          entrypoints = {
            search-with-searxng = {
              alias = selfhosted.searxng.alias;
            };
          };
        };
      });
    };
  };

  nixdots.persist.home = {
    directories = [
      ".local/share/vicinae"
    ];
  };
}
