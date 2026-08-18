{
  pkgs,
  lib,
  config,
  ...
}:
let
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
        assertion = cfg.flatpak.enable -> pkgs.stdenv.isLinux;
        message = "Flatpak is only available on GNU/Linux";
      }
      {
        assertion = cfg.homebrew.enable -> pkgs.stdenv.isDarwin;
        message = "Homebrew is currently only available on Darwin";
      }
    ];
  };
}
