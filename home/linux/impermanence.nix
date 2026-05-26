{
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.persist;
in
lib.mkIf cfg.enable {
  home.persistence."/persist" = {
    hideMounts = true;
    allowTrash = true;
    directories = cfg.home.directories;
    files = cfg.home.files;
  };
}
