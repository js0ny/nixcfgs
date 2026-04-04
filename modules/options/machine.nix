{
  lib,
  config,
  ...
}: {
  options.nixdots.machine = {
    headless = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this machine operates without a physical display/peripherals. Useful for disabling GUI modules.";
    };

    role = lib.mkOption {
      type = lib.types.enum ["host" "guest" "standalone"];
      default = "standalone";
      description = ''
        The infrastructure role of this machine:
        - 'host': A bare-metal hypervisor that runs other VMs (e.g., your Zephyrus if it hosts libvirt/qemu).
        - 'guest': A virtual machine or VPS instance.
        - 'standalone': A standard physical machine not acting as a hypervisor.
      '';
    };

    displayProtocol = lib.mkOption {
      type = lib.types.enum ["x11" "wayland" "none"];
      default =
        if config.nixdots.machine.headless
        then "none"
        else "wayland";
      description = ''
        The display protocol to use. 'x11' for Xorg, 'wayland' for Wayland, and 'none' for headless setups. This can be overridden by specific desktop manager modules if needed.
      '';
    };

    compat = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable compatibility features for running older software or games. This may include installing additional libraries or enabling certain kernel modules.";
    };

    wine = lib.mkOption {
      type = lib.types.bool;
      default = config.nixdots.machine.compat;
      description = "Whether to enable Wine for running Windows applications. This is typically enabled if 'compat' is true.";
    };

    nvidia = {
      mode = lib.mkOption {
        type = lib.types.enum ["disable" "nouveau" "nvidia" "vfio"];
        default = "disable";
        description = ''
          The NVIDIA driver mode to use:
          - 'disable': Do not enable NVIDIA drivers (default).
          - 'nouveau': Use the open-source Nouveau driver.
          - 'nvidia': Use the proprietary NVIDIA driver.
          - 'vfio': Enable VFIO passthrough for NVIDIA GPU (experimental).
        '';
      };
    };
  };
}
