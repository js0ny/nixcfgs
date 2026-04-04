{
  lib,
  config,
  ...
}: {
  options.nixdots.persist = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable impermanence module globally";
    };
    path = lib.mkOption {
      type = lib.types.str;
      default = "/persist";
      description = "Path to the persistence mount point";
    };
  };
}
