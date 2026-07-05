{
  lib,
  config,
  ...
}:
{
  options.nixdots.server = {
    enable = lib.mkEnableOption "Whether to enable server-specific configs.";
    ip = lib.mkOption {
      type = lib.types.str;
    };
    openHttp = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    openQuic = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
}
