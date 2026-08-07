{
  flake.nixosModules.immich = _: {
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
    nixdots.persist.system.directories = [
      "/var/lib/immich"
      "/var/lib/redis-immich"
    ];
  };
}
