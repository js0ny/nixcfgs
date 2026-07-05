{
  lib,
  config,
  ...
}:
{
  options.nixdots.machine = {
    role = lib.mkOption {
      type = lib.types.enum [
        "host"
        "guest"
        "standalone"
      ];
      default = "standalone";
      description = ''
        The infrastructure role of this machine:
        - 'host': A bare-metal hypervisor that runs other VMs.
        - 'guest': A virtual machine or VPS instance.
        - 'standalone': A standard physical machine not acting as a hypervisor.
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

  };
}
