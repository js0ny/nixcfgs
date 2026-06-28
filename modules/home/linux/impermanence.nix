{
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.persist;
in
lib.mkMerge [
  (lib.mkIf cfg.enable {
    home.persistence."/persist" = {
      hideMounts = true;
      allowTrash = true;
      directories = cfg.home.directories;
      files = cfg.home.files;
    };
  })
  (lib.mkIf cfg.nosnap.enable {
    home.persistence."${cfg.nosnap.path}" = {
      hideMounts = true;
      allowTrash = true;
      directories = cfg.nosnap.home.directories;
      files = cfg.nosnap.home.files;
    };
  })
]
