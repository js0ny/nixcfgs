{
  pkgs,
  lib,
  config,
  ...
}:
let
  absolutePathType = lib.types.addCheck lib.types.str (path: lib.hasPrefix "/" path);
  cfg = config.js0ny;
in
{
  options.js0ny = {
    flatpak = {
      enable = lib.mkEnableOption "Whether to enable flatpak package manager";
      packages = lib.mkOption {
        type = with lib.types; listOf (either str attrs);
      };
    };
    homebrew = {
      enable = lib.mkEnableOption "Whether to enable homebrew package manager";
      prefix = lib.mkOption {
        type = absolutePathType;
        default = "/opt/homebrew/";
      };
      formulae = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
      casks = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
      taps = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };
  };
  config = {
    assertions = [
      {
        assertion = cfg.flatpak.enable -> pkgs.stdenv.hostPlatform.isLinux;
        message = "Flatpak is only available on GNU/Linux";
      }
      {
        assertion = cfg.homebrew.enable -> pkgs.stdenv.hostPlatform.isDarwin;
        message = "Homebrew is currently only available on Darwin";
      }
    ];
  };
}
