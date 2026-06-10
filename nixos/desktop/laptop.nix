{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.nixdots.laptop;
in
lib.mkIf cfg.enable {
  environment.systemPackages = with pkgs; [
    acpi
    powertop
    lm_sensors
    gnome-firmware
  ];

  services.fwupd.enable = true;
  systemd.timers.fwupd-refresh.enable = false;
  nixdots.persist.system.directories = [ "/var/lib/fwupd" ];

  services.upower.enable = true;
  powerManagement.powertop.enable = true;

  security.sudo-rs.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [
        {
          command = lib.getExe pkgs.powertop;
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
