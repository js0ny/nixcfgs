{
  flake.nixosModules.navidrome =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      ep = config.nixdefs.endpoints;
      url = ep.navidrome.domain;
      remoteDir = "library:Music";
      mntDir = "/mnt/music";
      socketPath = "/run/navidrome/navidrome.sock";
      backupDir = "/var/backup/navidrome";
      cfg = config.services.navidrome;
    in
    {
      services.navidrome = {
        enable = true;
        # https://www.navidrome.org/docs/usage/configuration/options/
        settings = {
          Address = "unix:${socketPath}";
          MusicFolder = mntDir;
          DefaultTheme = "AMusic";
          EnableSharing = true;
          EnableInsightsCollector = false;
          Backup = {
            Path = "/var/backup/navidrome";
            # https://pkg.go.dev/github.com/robfig/cron#hdr-CRON_Expression_Format)
            Schedule = "@weekly";
            Count = 3;
          };
          EnforceNonRootUser = true;
        }
        // lib.optionalAttrs (url != null) {
          BaseUrl = ep.navidrome.publicUrl;
        };
      };

      users.users.nginx.extraGroups = [ cfg.group ];

      services.nginx.virtualHosts = lib.mkIf (url != null) {
        "${url}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://unix:${socketPath}:/";
          };
        };
      };

      systemd.tmpfiles.rules = [
        "d ${mntDir} 0755 root users -"
        "d ${backupDir} 0755 ${cfg.user} ${cfg.group} -"
      ];

      nixdots.persist.system.directories = [
        "/var/lib/navidrome"
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
    };
}
