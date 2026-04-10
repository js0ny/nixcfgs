{
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.persist;
in
{
  options.nixdots.persist.system = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable impermanence for system directories and files";
    };
    directories = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
    };
    files = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.system.enable {
    programs.fuse.userAllowOther = true;

    environment.persistence."${cfg.path}" = {
      hideMounts = true;
      directories = cfg.system.directories;
      files = cfg.system.files;
    };
  };
}
