{ pkgs, ... }:
{
  systemd.user.services.polkit-agent = {
    Unit = {
      Description = "Polkit agent";
      PartOf = [ "niri.service" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };

    Install = {
      WantedBy = [ "niri.target" ];
    };
  };
}
