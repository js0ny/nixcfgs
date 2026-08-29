{ pkgs, lib, ... }:

{
  systemd.services.jellyfin.after = [
    "rclone-mount-anime.service"
    "rclone-mount-tvseries.service"
  ];

  systemd.services.rclone-mount-anime =
    let
      remoteDir = "library:Anime";
      mntDir = "/mnt/anime";
    in
    {
      description = "Rclone mount for Anime";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "notify";
        ExecStart = /* bash */ ''
          ${lib.getExe pkgs.rclone} mount ${remoteDir} ${mntDir} \
            --config=/var/lib/rclone/rclone.conf \
            --allow-other \
            --umask=022 \
            --vfs-cache-mode=full \
            --vfs-cache-max-size=5G \
            --vfs-cache-max-age=24h \
            --dir-cache-time=72h \
            --log-level=INFO \
            --allow-non-empty
        '';

        ExecStop = "${lib.getExe' pkgs.fuse3 "fusermount3"} -u ${mntDir}";
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };
  systemd.services.rclone-mount-tvseries =
    let
      remoteDir = "library:Series";
      mntDir = "/mnt/tvseries";
    in
    {
      description = "Rclone mount for TV Series";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "notify";
        ExecStart = /* bash */ ''
          ${lib.getExe pkgs.rclone} mount ${remoteDir} ${mntDir} \
            --config=/var/lib/rclone/rclone.conf \
            --allow-other \
            --umask=022 \
            --vfs-cache-mode=full \
            --vfs-cache-max-size=5G \
            --vfs-cache-max-age=24h \
            --dir-cache-time=72h \
            --log-level=INFO \
            --allow-non-empty
        '';

        ExecStop = "${lib.getExe' pkgs.fuse3 "fusermount3"} -u ${mntDir}";
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };
  systemd.tmpfiles.rules = [
    "d /mnt/anime 0755 root users -"
    "d /mnt/tvseries 0755 root users -"
  ];
}
