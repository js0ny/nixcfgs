{ pkgs, ... }:
{
  security.apparmor.enable = true;

  services.dbus.apparmor = "enabled";

  environment.systemPackages = with pkgs; [
    apparmor-utils
  ];
}
