{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Force disable drkonqi
  systemd.services."drkonqi-coredump-processor@" = {
    wantedBy = lib.mkForce [ ];
    enable = lib.mkForce false;
  };
  systemd.user.services.coredump-notify = {
    description = "Coredump desktop notifier";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    path = [ config.systemd.package ];

    serviceConfig = {
      ExecStart = lib.escapeShellArgs [
        (lib.getExe pkgs.js0ny.coredump-notify)
        "--xdg-terminal-exec"
        (lib.getExe pkgs.xdg-terminal-exec)
      ];
      Restart = "always";
      RestartSec = 5;
    };
  };
}
