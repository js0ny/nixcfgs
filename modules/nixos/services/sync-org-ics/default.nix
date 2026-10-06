{
  flake.nixosModules.sync-org-ics =
    {
      lib,
      pkgs,
      config,
      secrets,
      ...
    }:
    let
      sopsFile = secrets + "/radicale.yaml";
      owner = "orgmode";
      group = "orgmode";
      outputPath = "/var/lib/orgmode/org.ics";
      requiredServices = [
        "rclone-mount-org.service"
      ]
      ++ lib.optionals (config.services.radicale.enable) [
        "radicale.service"
      ];
    in
    {
      users.users.${owner} = {
        inherit group;
        isSystemUser = true;
        home = "/var/lib/${owner}";
        createHome = true;
        description = "Orgmode syncer service user";
      };
      users.groups.${group} = { };
      sops.secrets = {
        radicale_org_url = { inherit owner group sopsFile; };
        radicale_username = { inherit owner group sopsFile; };
        radicale_passwd_org = {
          inherit owner group sopsFile;
          key = "radicale_passwd";
        };
      };
      js0ny.persist.stores.state.directories = [ "/var/lib/orgmode" ];
      sops.templates."orgmode.vdirsyncer.ini" = {
        content = /* ini */ ''
          [general]
          status_path = "/var/lib/orgmode/vdirsyncer_status"

          [pair org_calendar]
          a = "org_calendar_local"
          b = "org_calendar_radicale"
          collections = null
          conflict_resolution = "a wins"
          partial_sync = "revert"

          [storage org_calendar_local]
          type = "singlefile"
          path = "${outputPath}"
          read_only = true

          [storage org_calendar_radicale]
          type = "caldav"
          url = "${config.sops.placeholder.radicale_org_url}"
          username = "${config.sops.placeholder.radicale_username}"
          password.fetch = ["command", "cat", "${config.sops.secrets.radicale_passwd_org.path}"]
          item_types = ["VEVENT"]
        '';
        inherit owner group;
        path = "/var/lib/orgmode/orgmode.vdirsyncer.ini";
      };

      systemd.services.sync-org-ics = {
        description = "Sync Org Agenda from source to iCalendar file";
        enable = true;
        requires = requiredServices;
        after = requiredServices;
        script = ''
          ${lib.getExe pkgs.emacs} --quick --batch --load ${./publish-calendar.el}

          ${lib.getExe pkgs.vdirsyncer} --config ${
            config.sops.templates."orgmode.vdirsyncer.ini".path
          } discover org_calendar

          ${lib.getExe pkgs.vdirsyncer} --config ${config.sops.templates."orgmode.vdirsyncer.ini".path} sync
        '';
        serviceConfig = {
          User = "orgmode";
          Group = "orgmode";
          Type = "oneshot";
          StateDirectory = "orgmode";
          Restart = "on-failure";
          RestartSec = "1min";
        };
        unitConfig = {
          StartLimitIntervalSec = "15min";
          StartLimitBurst = 3;
        };
        environment = {
          ORG_CALENDAR_ROOT = "${config.js0ny.rclone.mounts.org.mountPoint}/tasks";
          ORG_CALENDAR_OUTPUT = outputPath;
        };
      };
      systemd.timers.sync-org-ics = {
        enable = true;
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "hourly";
          Persistent = true;
        };
      };

      js0ny.rclone.mounts.org = {
        remote = "pcloud:Org";
        mountPoint = "/mnt/org";
        settings.allow-non-empty = true;
      };
    };
}
