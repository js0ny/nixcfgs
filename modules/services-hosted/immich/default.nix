{
  flake.nixosModules.immich =
    { config, lib, ... }:
    let
      inherit (config.services.immich) group mediaLocation user;
      storageDirectories = [
        "upload"
        "library"
        "thumbs"
        "encoded-video"
        "profile"
        "backups"
      ];
    in
    {
      services.immich = {
        enable = true;
        host = "0.0.0.0";
        port = 2283;
        database.createDB = true;
        redis.enable = true;
        # https://docs.immich.app/install/config-file
        settings = {
          newVersionCheck.enabled = false;
          map = {
            enabled = true;
            lightStyle = "https://tiles.immich.cloud/v1/style/light.json";
            darkStyle = "https://tiles.immich.cloud/v1/style/dark.json";
          };
          storageTemplate = {
            enabled = true;
            hashVerificationEnabled = true;
            template = "{{y}}/{{MM}}/{{filename}}";
          };
        };
      };
      # https://docs.immich.app/administration/system-integrity/#folder-checks
      systemd.tmpfiles.rules = lib.concatMap (directory: [
        "d ${mediaLocation}/${directory} 0750 ${user} ${group} -"
        "f ${mediaLocation}/${directory}/.immich 0640 ${user} ${group} -"
      ]) storageDirectories;

      nixdots.persist.system.directories = [
        "/var/lib/immich"
        {
          directory = "/var/lib/redis-immich";
          user = "redis-immich";
          group = "redis-immich";
        }
      ];
    };
}
