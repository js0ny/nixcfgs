{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  fx = config.nixdefs.consts.firefox.profileDir;
  fxProfile = config.nixdots.programs.firefox.defaultProfile;
  selfhosted = config.nixdefs.selfhosted;
  vicinae-extensions = inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system};
  inherit (lib) mkDefault;
in
{
  # see block-desktop-entries.nix for disable desktop entries via vicinae
  programs.vicinae = {
    enable = true;
    # https://github.com/vicinaehq/extensions/tree/main/extensions
    extensions = with vicinae-extensions; [
      # keep-sorted start
      bluetooth
      firefox
      niri
      nix
      podman
      protondb-search
      searxng
      wifi-commander
      # keep-sorted end
      # systemd # https://github.com/vicinaehq/extensions/blob/20d6a13d2a389e61619b8540b8af746705409322/flake.nix#L67
    ];
    systemd = {
      enable = true;
      target = "waylandwm-session.target";
      autoStart = true;
    };
    # https://docs.vicinae.com/config
    settings = {
      "$schema" = "https://vicinae.com/schemas/config.json";
      telemetry = {
        system_info = false;
      };
      consider_preedit = false;
      close_on_focus_loss = true;
      providers = {
        "@knoopx/vicinae-extension-firefox-0" = {
          preferences = {
            "profile_dir" = "${fx}/${fxProfile}";
          };
        };
        clipboard.entrypoints = {
          "history".alias = mkDefault "clip";
        };
        system.entrypoints.run = {
          alias = mkDefault ">";
          # run directly without open a terminal window
          # accompanied with nix-index comma
          preferences."default-action" = "run";
        };
        "@knoopx/vicinae-extension-nix-0".entrypoints = {
          "home-manager-options".alias = mkDefault "hm";
          "options".alias = mkDefault "no";
          "packages".alias = mkDefault "np";
        };
        "@dagimg-dot/vicinae-extension-wifi-commander-0" = {
          preferences = {
            "network-cli-tool" = mkDefault "iwctl";
          };
        };
      }
      // (lib.optionalAttrs selfhosted.searxng.enable {
        "@Ninetonine/vicinae-extension-searxng-0" = {
          preferences = {
            "instance_domain" = selfhosted.searxng.url;
            "default_category" = mkDefault "general";
            "details_start_open" = mkDefault false;
            "keep_previous_search" = mkDefault true;
            "languages" = mkDefault config.nixdots.core.locales.guiLocale;
          };
          entrypoints = {
            search-with-searxng = {
              alias = selfhosted.searxng.integrations.alias;
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
  makeMutable = [ ".config/vicinae/settings.json" ];
}
