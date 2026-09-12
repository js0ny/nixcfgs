{ lib, ... }:
{
  options.js0ny.hardware.gpu = {
    driver = lib.mkOption {
      type = lib.types.enum [
        "none" # igpu
        "disable" # igpu
        "nouveau"
        "nvidia"
        "vfio" # EXPERIMENTAL
      ];
      default = "none";
      description = ''
        The GPU Hardware and driver to use
        - 'none': iGPU
        - 'nouveau': Use the open-source Nouveau driver.
        - 'nvidia': Use the proprietary NVIDIA driver.
        - 'vfio': Enable VFIO passthrough for NVIDIA GPU (experimental).
      '';
    };
    # lspci | grep -E "VGA|3D|Display" # output is hex, but in nixos, decimal is required
    busIds = {
      nvidia = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "PCI:1:0:0";
        description = ''
          Bus ID of the NVIDIA GPU for PRIME offload.
        '';
      };
      intel = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "PCI:0:2:0";
        description = ''
          Bus ID of the Intel GPU for PRIME offload.
        '';
      };
      amdgpu = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "PCI:5:0:0";
        description = ''
          Bus ID of the AMD GPU for PRIME offload.
        '';
      };
    };
  };
}
