{ ... }:
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
  systemd.tmpfiles.rules = [
    "d /var/lib/rclone 0755 rclone rclone - -"
  ];
}
