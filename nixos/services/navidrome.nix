{
  pkgs,
  lib,
  config,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  ipAddr = ep.navidrome.bindAddress;
  port = ep.navidrome.port;
  portStr = ep.navidrome.portStr;
  url = ep.navidrome.domain;
  remoteDir = "library:Music";
  mntDir = "/mnt/music";
in
{
  services.navidrome = {
    enable = true;
    settings = {
      Address = ipAddr;
      Port = port;
      MusicFolder = mntDir;
      DefaultTheme = "AMusic";
      EnableSharing = true;
    }
    // lib.optionalAttrs (url != null) {
      BaseUrl = ep.navidrome.publicUrl;
    };
  };

  services.nginx.virtualHosts = lib.mkIf (url != null) {
    "${url}" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:${portStr}";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d ${mntDir} 0755 root users -"
  ];

  systemd.services.navidrome.after = [ "rclone-mount-music.service" ];

  systemd.services.rclone-mount-music = {
    description = "Rclone mount for Music";
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
}
