# NOTE: This module only contains programs that has to be configured in both home-manager and NixOS
{
  lib,
  config,
  ...
}:
{
  options.nixdots.programs = {
    obs-studio = {
      enable = lib.mkEnableOption "Enable OBS Studio for streaming and recording.";
    };
    firefox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Firefox web browser.";
      };
      defaultProfile = lib.mkOption {
        type = lib.types.str;
        default = config.js0ny.user.name;
        description = "Default profile that applies to firefox";
      };
    };
    thunderbird = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Thunderbird email client.";
      };
      defaultProfile = lib.mkOption {
        type = lib.types.str;
        default = config.js0ny.user.name;
        description = "Default profile that applies to thunderbird";
      };
    };
    dolphin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Dolphin file manager.";
      };
    };
    steam = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Steam gaming platform.";
      };
    };
    onlyoffice = {
      enable = lib.mkEnableOption ''
        Whether to enable onlyoffice-desktopeditors.
        Office suite that combines text, spreadsheet and presentation editors allowing to create, view and edit local documents
      '';
    };
  };
}
