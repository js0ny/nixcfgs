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
      hideMounts = true;
      allowTrash = true;
      directories = cfg.home.directories;
      files = cfg.home.files;
    };
  };
}
