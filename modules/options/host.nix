{ lib, config, ... }: {
  options.js0ny.host = {
    hostName = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "Hostname for the machine.";
    };
    timezones = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      example = [ "Etc/UTC" ];
      description = "Timezones for the system, the first item will be set as timezone.";
    };
    flakeDir = lib.mkOption {
      type = lib.types.str;
      default = config.nixdots.core.dots;
      description = "Path for flake directory.";
    };
  };
}
