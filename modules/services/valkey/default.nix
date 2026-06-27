{
  flake.nixosModules.valkey =
    { pkgs, lib, ... }:
    {
      services.redis.package = lib.mkDefault pkgs.valkey;
      nixdots.persist.system.directories = [
        "/var/lib/redis"
      ];
    };
}
