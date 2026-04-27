{
  lib,
  pkgs,
  ...
}:
{
  options.nixdots.linux = {
    enable = lib.mkEnableOption "Whether this is a linux host";
    # boot.loader = lib.mkOption {
    #   type = lib.types.enum [
    #     "systemd-boot"
    #     "grub"
    #   ];
    #   default = "systemd-boot";
    # };
    nixos = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether this is a NixOS host.
      '';
    };
    display = lib.mkOption {
      type = lib.types.enum [
        "wayland"
        "none"
      ];
      default = "none";
      description = ''
        The display protocol to use. 'wayland' for Wayland, and 'none' for headless setups. This can be overridden by specific desktop manager modules if needed.
      '';
    };
    gpu = lib.mkOption {
      type = lib.types.enum [
        "none" # igpu
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
  };
}
