{ pkgs, lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.js0ny.hardware = rec {
    laptop.enable = lib.mkEnableOption "Whether the host is a laptop";
    microphone = {
      enable = mkOption {
        type = types.bool;
        default = pkgs.stdenv.isDarwin || laptop.enable;
        description = "Whether the host has a microphone";
      };
    };
  };
}
