{
  lib,
  config,
  ...
}: {
  options.nixdots.server = {
    enable = lib.mkEnableOption "Whether to enable server-specific configs.";
    ip = lib.mkOption {
      type = lib.types.str;
    };
  };
}
