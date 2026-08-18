{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.js0ny.hardware;
in
{
  options.js0ny.hardware = {
    laptop.enable = lib.mkEnableOption "Whether the host is a laptop";
    microphone = {
      enable = mkOption {
        type = types.bool;
        default = (pkgs.stdenv.isDarwin || cfg.laptop.enable);
        description = "Whether the host has a microphone";
      };
    };
    cpu = {
      nproc = mkOption {
        type = types.int;
        default = 0;
        description = "Number of virtual processors visible to the system, get it via `nproc` command line";
      };
    };
  };
}
