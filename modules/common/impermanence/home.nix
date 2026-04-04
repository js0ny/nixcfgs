{
  lib,
  config,
  ...
}: let
  cfg = config.nixdots.persist;
in {
  options.nixdots.persist.home = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Enable impermanence for home directory";
    };
    directories = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
    };
    files = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
    };
  };

  config = lib.mkIf cfg.home.enable {
    home.persistence."/persist" = {
      directories = cfg.home.directories;
      files = cfg.home.files;
    };
  };
}
