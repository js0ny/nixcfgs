{ pkgs, lib, ... }:
{
  services.swayidle = {
    enable = true;
    systemdTargets = [ "waylandwm-session.target" ];
    timeouts = [
      {
        timeout = 300;
        command = lib.mkDefault lib.getExe pkgs.hyprlock;
      }
      {
        timeout = 600;
        command = lib.mkDefault "${lib.getExe' pkgs.systemd "systemctl"} suspend";
      }
    ];
  };
}
