{
  config,
  lib,
  ...
}:
let
  cfg = config.services.jellyfin;
in
{
  environment.etc."fail2ban/filter.d/jellyfin.conf".text = /* ini */ ''
    [Definition]
    failregex = ^.*Authentication request for .* has been denied \(IP: "<ADDR>"\)\.
  '';

  services.fail2ban.jails = {
    jellyfin.settings = {
      backend = "auto";
      enabled = true;
      port = "80,443";
      protocol = "tcp";
      filter = "jellyfin";
      maxretry = 3;
      bantime = 86400;
      findtime = 43200;
      logpath = "${cfg.logDir}/log_*.log";
    };
  };

  systemd.services.fail2ban-jellyfin-reload = {
    description = "Reload Fail2Ban jellyfin jail";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${lib.getExe' config.services.fail2ban.package "fail2ban-client"} reload jellyfin";
    };
  };

  systemd.timers.fail2ban-jellyfin-reload = {
    description = "Reload Fail2Ban jellyfin jail daily";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 00:45:00";
      Persistent = true;
    };
  };
}
