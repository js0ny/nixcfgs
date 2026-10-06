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
      mntDir = config.js0ny.rclone.mounts.music.mountPoint;
      socketPath = "/run/navidrome/navidrome.sock";
      backupDir = "/var/backup/navidrome";
      cfg = config.services.navidrome;
    in
    {
      services.navidrome = {
        enable = true;
        # [Human Intervention] Enable and configure plugins in Navidrome's Plugins page.
        plugins = [ pkgs.js0ny.navidromePlugins.lyrics-bin ];
        # https://www.navidrome.org/docs/usage/configuration/options/
        settings = {
          Address = "unix:${socketPath}";
          MusicFolder = mntDir;
          DefaultTheme = "AMusic";
          EnableSharing = true;
          EnableInsightsCollector = false;
          LyricsPriority = ".ttml,.yaml,.yml,.elrc,.lrc,.srt,.txt,embedded,nd-lyrics";
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
        "d ${backupDir} 0755 ${cfg.user} ${cfg.group} -"
      ];

      js0ny.persist.stores.state.directories = [ "/var/lib/navidrome" ];

      systemd.services.navidrome.after = [ "rclone-mount-music.service" ];

      js0ny.rclone.mounts.music = {
        remote = "library:Music";
        mountPoint = "/mnt/music";
        mountPointGroup = "users";
        settings.allow-non-empty = true;
      };
    };
}
