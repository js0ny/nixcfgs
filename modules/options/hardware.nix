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
  imports = [
    ./hardware/gpu.nix
    ./hardware/laptop.nix
  ];

  options.js0ny.hardware = {
    localInterfaces = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "enp1s0"
        "wlp3s0"
      ];
      description = "Network interfaces used for local-network services; does not imply network trust.";
    };
    laptop = {
      enable = lib.mkEnableOption "Whether the host is a laptop";
      vendor = lib.mkOption {
        type =
          /*nixfmt:disable*/
          with lib.types; nullOr (enum [
            "asus"
            "apple"
          ]);
          /*nixfmt:enable*/
        default = null;
      };
    };
    type = mkOption {
      type = lib.types.enum [
        "bare-metal"
        "virtual-machine"
      ];
      default = "virtual-machine";
    };
    microphone = {
      enable = mkOption {
        type = types.bool;
        default = (pkgs.stdenv.hostPlatform.isDarwin || cfg.laptop.enable);
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
