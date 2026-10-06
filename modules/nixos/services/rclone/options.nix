{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  defaultConfigFile = config.sops.secrets.rclone.path;
  mounts = config.js0ny.rclone.mounts;
  mountArgs =
    settings:
    lib.concatLists (
      lib.mapAttrsToList (
        name: value:
        if builtins.isBool value then lib.optional value "--${name}" else [ "--${name}=${toString value}" ]
      ) settings
    );
in
{
  options.js0ny.rclone.mounts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          remote = lib.mkOption {
            type = lib.types.str;
            example = "library:Music";
            description = "Rclone remote and directory to mount.";
          };
          mountPoint = lib.mkOption {
            type = lib.types.strMatching "/.*";
            example = "/mnt/music";
            description = "Absolute runtime path of the mount point.";
          };
          configFile = lib.mkOption {
            type = lib.types.strMatching "/.*";
            default = defaultConfigFile;
            defaultText = lib.literalExpression "config.sops.secrets.rclone.path";
            description = "Absolute runtime path of the rclone configuration containing credentials.";
          };
          mountPointGroup = lib.mkOption {
            type = lib.types.str;
            default = "root";
            description = "Group owning the root-owned mount point directory with mode 0755.";
          };
          settings = lib.mkOption {
            type =
              with lib.types;
              attrsOf (oneOf [
                bool
                str
                int
              ]);
            default = { };
            description = ''
              Rclone mount options without the leading --. True enables a flag,
              false omits it, and strings or integers supply its value.
              Use the dedicated fields for the remote, mount point and configuration file.
              See https://rclone.org/commands/rclone_mount/ for supported options.
            '';
          };
        };

        # https://rclone.org/commands/rclone_mount/
        config.settings = lib.mapAttrs (_: lib.mkDefault) {
          allow-other = true;
          umask = "022";
          vfs-cache-mode = "full";
          vfs-cache-max-size = "5G";
          vfs-cache-max-age = "24h";
          dir-cache-time = "72h";
          log-level = "INFO";
        };
      }
    );
    default = { };
    description = "Named rclone mounts managed by rclone-mount-<name>.service.";
  };

  config = {
    assertions = lib.mapAttrsToList (name: mount: {
      assertion =
        lib.intersectLists [ "config" "remote" "mountPoint" ] (lib.attrNames mount.settings) == [ ];
      message = "js0ny.rclone.mounts.${name}: use the dedicated remote, mountPoint and configFile fields.";
    }) mounts;

    systemd.services = lib.mapAttrs' (
      name: mount:
      lib.nameValuePair "rclone-mount-${name}" {
        description = "Rclone mount for ${name}";
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "notify";
          ExecStart = utils.escapeSystemdExecArgs (
            [
              (lib.getExe pkgs.rclone)
              "mount"
              mount.remote
              mount.mountPoint
              "--config=${mount.configFile}"
            ]
            ++ mountArgs mount.settings
          );
          ExecStop = utils.escapeSystemdExecArgs [
            (lib.getExe' pkgs.fuse3 "fusermount3")
            "-u"
            mount.mountPoint
          ];
          Restart = "on-failure";
          RestartSec = "10s";
        };
      }
    ) mounts;

    systemd.tmpfiles.rules = lib.mapAttrsToList (
      _: mount:
      let
        path = builtins.toJSON (lib.replaceStrings [ "%" ] [ "%%" ] mount.mountPoint);
      in
      "d ${path} 0755 root ${mount.mountPointGroup} -"
    ) mounts;
  };
}
