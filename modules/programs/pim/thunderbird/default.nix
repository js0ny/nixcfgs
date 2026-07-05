{
  flake.nixosModules.thunderbird = { pkgs, ... }: {
    programs.thunderbird = {
      enable = true;
      package = pkgs.nixpaks.thunderbird;
      policies = {
        DisableTelemetry = true;
        ExtensionSettings =
          with builtins;
          let
            extension = short: uuid: {
              name = uuid;
              value = {
                install_url = "https://addons.thunderbird.net/downloads/latest/addon-${short}-latest.xpi";
                installation_mode = "normal_installed";
              };
            };
          in
          listToAttrs [
            (extension "988699" "thunderai@micz.it") # ThunderAI
            (extension "988018" "addon@darkreader.org") # Dark Reader
            (extension "987885" "tbkeys-lite@addons.thunderbird.net") # TBKeys Lite
            (extension "988342" "external-editor-revived@tsundere.moe") # External Editor Revived
          ];
      };
      preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;
      };
    };
  };
  flake.homeModules.thunderbird =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.nixdots.programs.thunderbird;
      profile = config.nixdots.user.name;
      nur-addons = pkgs.nur.repos.rycee.thunderbird-addons;
      isNixOS = config.nixdots.linux.enable && config.nixdots.linux.nixos;
    in
    lib.mkIf cfg.enable {
      programs.thunderbird = {
        enable = true;
        package = if isNixOS then pkgs.nixpaks.thunderbird else pkgs.thunderbird;
        profiles."${profile}" = {
          isDefault = true;
          settings = {
            "mailnews.message_display.disable_remote_image" = false;
          };
          extensions = with nur-addons; [ tbkeys ];
        };
      };
      nixdots.persist.home = {
        directories = [
          ".thunderbird"
        ];
      };
      home.packages = lib.optionals (pkgs.stdenv.isLinux) [ pkgs.birdtray ];
    };

  flake.nixosModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.nixosModules.thunderbird ];
  };
  flake.homeModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.homeModules.thunderbird ];
  };
}
