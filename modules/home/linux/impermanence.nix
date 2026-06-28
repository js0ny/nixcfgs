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
      directories = lib.unique cfg.home.directories;
      files = lib.unique cfg.home.files;
    };
  })
  (lib.mkIf cfg.nosnap.enable {
    home.persistence."${cfg.nosnap.path}" = {
      hideMounts = true;
      allowTrash = true;
      directories = lib.unique cfg.nosnap.home.directories;
      files = lib.unique cfg.nosnap.home.files;
    };
  })
]
