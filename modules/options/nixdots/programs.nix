# NOTE: This module only contains programs that has to be configured in both home-manager and NixOS
{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots;
in
{
  options.nixdots.programs = {
    obs-studio = {
      enable = lib.mkEnableOption "Enable OBS Studio for streaming and recording.";
    };
    zsh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = (cfg.user.shell == pkgs.zsh) || (cfg.apps.interactiveShell.exe == "zsh");
        description = "Enable Zsh.";
      };
    };
    shellAliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Shell aliases shared across Home Manager shells.";
    };
    chromium = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Chromium web browser.";
      };
    };
    firefox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable Firefox web browser.";
      };
      defaultProfile = lib.mkOption {
        type = lib.types.str;
        default = config.nixdots.user.name;
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
        default = config.nixdots.user.name;
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
    rime = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = if (config.nixdots.machine.role == "host") then true else false;
        description = "Enable Rime input method.";
      };
    };
    steam = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = if (config.nixdots.machine.role == "host") then true else false;
        description = "Enable Steam gaming platform.";
      };
    };
  };
}
