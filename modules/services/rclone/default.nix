{
  flake.nixosModules.rclone =
    { secrets, ... }:
    {
      programs.fuse = {
        enable = true;
        userAllowOther = true;
      };

      users.users.rclone = {
        isSystemUser = true;
        group = "rclone";
        home = "/var/lib/rclone";
        createHome = true;
        description = "Rclone service user";
      };
      users.groups.rclone = { };

      sops.secrets = {
        rclone = {
          key = "data";
          sopsFile = secrets + /files/rclone.yaml;
          path = "/var/lib/rclone/rclone.conf";
          owner = "root";
        };
      };
    };
}
