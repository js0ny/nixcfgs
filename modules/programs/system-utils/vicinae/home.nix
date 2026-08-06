{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  selfhosted = config.nixdefs.selfhosted;
  vicinae-extensions = inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system};
  pkg = pkgs.vicinae;
  linux = pkgs.stdenv.isLinux;
in
lib.mkMerge [
  (lib.mkIf pkgs.stdenv.isLinux {
    # see block-desktop-entries.nix for disable desktop entries via vicinae
    programs.vicinae = {
      enable = true;
      package = pkg;
      # https://github.com/vicinaehq/extensions/tree/main/extensions
      extensions = with vicinae-extensions; [
        # keep-sorted start
        firefox
        flathub-search
        nerdfont-search
        niri
        nix
        podman
        protondb-search
        searxng
        wifi-commander
        zed-recents
        # keep-sorted end
        # systemd # https://github.com/vicinaehq/extensions/blob/20d6a13d2a389e61619b8540b8af746705409322/flake.nix#L67
      ];
      systemd = {
        enable = true;
        autoStart = true;
      };
      # https://docs.vicinae.com/config
      settings = {
        "$schema" = "https://vicinae.com/schemas/config.json";
        telemetry = {
          system_info = false;
        };
        keybinds = {
          "toggle-action-panel" = "control+B";
        };
        consider_preedit = false;
        close_on_focus_loss = true;
        providers = {
          core.entrypoints = {
            sponsor.enabled = false;
            store.preferences.alwaysShowIntro = false;
          };
          raycast-compat.entrypoints = {
            store.preferences.alwaysShowIntro = false;
          };
          clipboard = {
            preferences = {
              encryption = true;
              eraseOnStartup = false;
              ignorePasswords = true;
              monitoring = true;
            };
            entrypoints = {
              "history" = {
                alias = "clip";
                preferences.defaultAction = "copy";
              };
            };
          };
          system.entrypoints.run = {
            alias = ">";
            # run directly without open a terminal window
            # accompanied with nix-index comma
            preferences."default-action" = "run";
          };
          "@knoopx/vicinae-extension-firefox-0" = {
            preferences = {
              "profile_dir" = config.nixdefs.consts.firefox.profileDir;
            };
          };
          "@knoopx/vicinae-extension-nix-0".entrypoints = {
            "home-manager-options".alias = "hm";
            "options".alias = "no";
            "packages".alias = "np";
          };
          "@dagimg-dot/vicinae-extension-wifi-commander-0" = {
            preferences = {
              "network-cli-tool" = "nmcli";
            };
          };
        }
        // (lib.optionalAttrs selfhosted.searxng.enable {
          "@Ninetonine/vicinae-extension-searxng-0" = {
            preferences = {
              "instance_domain" = selfhosted.searxng.url;
              "default_category" = "general";
              "details_start_open" = false;
              "keep_previous_search" = true;
              "languages" = config.nixdots.core.locales.guiLocale;
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

    nixdots.persist.nosnap.home = {
      directories = [
        ".local/share/vicinae"
      ];
    };
    makeMutable = [ ".config/vicinae/settings.json" ];

    programs.chromium.extensions = [
      { id = "kcmipingpfbohfjckomimmahknoddnke"; } # Vicinae Integration
    ];

    # located in:
    # ${pkgs.vicinae}/share/vicinae/native-host/chromium/
    # which is not a default path for nix packages, so we need to add it manually
    xdg.configFile."chromium/NativeMessagingHosts/com.vicinae.vicinae.json".text = builtins.toJSON {
      name = "com.vicinae.vicinae";
      description = "IPC Native Messaging Host";
      path = "${pkg}/libexec/vicinae/vicinae-browser-link";
      type = "stdio";
      allowed_origins = [
        "chrome-extension://kcmipingpfbohfjckomimmahknoddnke/"
      ];
    };
    home.packages = with pkgs; [ sqlite-interactive ];
  })
  (lib.mkIf (pkgs.stdenv.isLinux && config.programs.zoxide.enable) {
    programs.vicinae = {
      extensions = with vicinae-extensions; [ zoxide-recent-directories ];
      settings = {
        providers = {
          "@c4n4m1/vicinae-extension-zoxide-recent-directories-0" = {
            preferences = {
              application = lib.getExe' pkgs.xdg-utils "xdg-open";
              defaultFilter = "all";
              alternativeApplication = lib.getExe pkgs.xdg-terminal-exec;
            };
            entrypoints.recent-directories.alias = "zo";
          };
        };
      };
    };
  })
]
