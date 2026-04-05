{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mapAttrsToList mkEnableOption mkIf mkMerge mkOption types;
  cfg = config.programs.dolphin;
  dolphinLib = import ../../../lib/dolphin.nix {inherit lib;};

  actionType = types.submodule ({...}: {
    options = {
      name = mkOption {
        type = types.str;
        description = "Action label shown in Dolphin.";
      };
      exec = mkOption {
        type = types.str;
        description = "Command executed by this Dolphin action.";
      };
      icon = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Optional icon for this action.";
      };
      extraFields = mkOption {
        type = types.attrs;
        default = {};
        description = "Additional fields written to the [Desktop Action ...] section.";
      };
    };
  });

  serviceType = types.submodule ({...}: {
    options = {
      mimeType = mkOption {
        type = types.str;
        default = "all/allfiles";
        description = "Mime types matched by this Dolphin service.";
      };
      icon = mkOption {
        type = types.str;
        default = "system-run";
        description = "Top-level icon shown for this Dolphin service.";
      };
      desktopEntryExtra = mkOption {
        type = types.attrs;
        default = {};
        description = "Additional fields merged into the [Desktop Entry] section.";
      };
      actionOrder = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = "Optional explicit order for the Actions= field.";
      };
      actions = mkOption {
        type = types.attrsOf actionType;
        default = {};
        description = "Actions exposed by this Dolphin service file.";
      };
    };
  });
in {
  options.programs.dolphin = {
    enable = mkEnableOption "Dolphin file manager and its service menu integration.";
    services = mkOption {
      type = types.attrsOf serviceType;
      default = {};
      description = "Declarative Dolphin service menu entries.";
    };
  };

  config = mkIf cfg.enable {
    nixdots.persist.home = {
      directories = [
        ".local/share/kxmlgui5/dolphin"
      ];
      files = [
        ".config/dolphinrc"
      ];
    };
    home.packages = with pkgs.kdePackages; [
      dolphin
      dolphin-plugins # dolphin git integration
      konsole # dolphin terminal integration
    ];

    xdg.dataFile = mkMerge (
      mapAttrsToList (
        name: serviceCfg:
          (dolphinLib.mkDolphinService name serviceCfg).xdg.dataFile
      )
      cfg.services
    );
  };
}
