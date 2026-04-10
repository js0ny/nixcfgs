{
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.persist;
in
{
  config = lib.mkIf cfg.home.enable {
    home.persistence."/persist" = {
      directories = cfg.home.directories;
      files = cfg.home.files;
    };
  };
}
