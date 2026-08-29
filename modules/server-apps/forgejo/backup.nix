{ config, lib, ... }:
let
  cfg = config.services.forgejo;

  dumpDir = "/var/backup/forgejo";
in
{
  assertions = [
    {
      assertion = cfg.enable;
      message = "Forgejo backup requires services.forgejo.enable.";
    }
  ];

  systemd.tmpfiles.rules = [
    "d ${dumpDir} 0750 ${cfg.user} ${cfg.group} - -"
  ];

  systemd.services.forgejo-dump = {
    description = "Create Forgejo dump";

    after = [ "forgejo.service" ];
    requires = [ "forgejo.service" ];

    environment = {
      HOME = cfg.stateDir;
      USER = cfg.user;
      FORGEJO_WORK_DIR = cfg.stateDir;
      FORGEJO_CUSTOM = cfg.customDir;
    };

    serviceConfig = {
      Type = "oneshot";
      User = cfg.user;
      Group = cfg.group;
      WorkingDirectory = dumpDir;

      # https://forgejo.org/docs/v15.0/admin/command-line/#dump
      ExecStart = lib.escapeShellArgs [
        (lib.getExe cfg.package)
        "dump"
        "--verbose"
        "--type"
        "tar.zst"
      ];

      UMask = "0077";
      NoNewPrivileges = true;
      PrivateTmp = true;
    };
  };

  systemd.timers.forgejo-dump = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "Mon *-*-* 03:15:00";
      Persistent = true;
      RandomizedDelaySec = "10m";
    };
  };
}
