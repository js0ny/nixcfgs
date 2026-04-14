{ config, ... }:
let
  firefox = config.home.username;
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
            profile_dir = ".mozilla/firefox/${firefox}";
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
      };
    };
  };

  nixdots.persist.home = {
    directories = [
      ".local/share/vicinae"
    ];
  };
}
