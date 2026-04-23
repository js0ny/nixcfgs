{
  lib,
  config,
  ...
}:
let
  cfg = config.home.directories;
  home = config.home.homeDirectory;
  user = config.home.username;
  dirType = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable management for this directory";
      };
      create = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Create directory via systemd.tmpfiles";
      };
      persist = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Persist directory via home.impermanence";
      };
      # TODO: Implement backup and sync
      backup = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Backup directory via restic";
      };
      backupExclude = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Subdirectories to exclude from restic backup";
      };
      sync = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Sync directory via rclone";
      };
      pin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Pin directory to the sidebar of file managers";
      };
      icon = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Icon name for the directory";
      };
      index = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether index the full folder or not";
      };
    };
  };
in
{
  options.home.directories = lib.mkOption {
    type = lib.types.attrsOf dirType;
    default = { };
    description = "Managed home directories";
  };
  config = {
    nixdots.persist.home.directories = lib.attrNames (
      lib.filterAttrs (_: dir: dir.enable && dir.persist) cfg
    );

    systemd.user.tmpfiles.rules = lib.mapAttrsToList (
      name: _: "d ${home}/${name} 0755 ${user} users -"
    ) (lib.filterAttrs (_: dir: dir.enable && dir.create && !dir.persist) cfg);

    gtk.gtk3.bookmarks = lib.mapAttrsToList (name: _: "file://${home}/${name}") (
      lib.filterAttrs (_: dir: dir.enable && dir.pin) cfg
    );
  };
}
