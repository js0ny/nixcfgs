{
  lib,
  config,
  ...
}:
{
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
    rootOn = lib.mkOption {
      type = lib.types.enum [
        "tmpfs"
        "btrfs"
        "zfs"
      ];
      default = "btrfs";
      description = "Only btrfs is implemented";
    };
    system = {
      directories = lib.mkOption {
        type = with lib.types; listOf (either str attrs);
        default = [ ];
      };
      files = lib.mkOption {
        type = with lib.types; listOf (either str attrs);
        default = [ ];
      };
    };
    home = {
      directories = lib.mkOption {
        type = with lib.types; listOf (either str attrs);
        default = [ ];
      };
      files = lib.mkOption {
        type = with lib.types; listOf (either str attrs);
        default = [ ];
      };
    };
  };
}
