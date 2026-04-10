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
      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "List of OBS Studio plugins to install.";
      };
      theme = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          OBS Studio theme to use. This option will merge the theme config to main OBS config.
          The theme name should be found by manually setting the theme in OBS and then checking the generated config file at ~/.config/obs-studio/user.ini.
          The theme name is the value of "Appearance.Theme" in that file.
        '';
      };
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
