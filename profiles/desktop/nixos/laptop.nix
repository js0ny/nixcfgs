{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.js0ny.hardware.laptop;
in
lib.mkIf cfg.enable {
  environment.systemPackages = with pkgs; [
    acpi
    powertop
  ];

  services.upower = {
    enable = true;
    ignoreLid = lib.mkDefault false;
  };
  powerManagement.powertop.enable = true;

  security.sudo-rs.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [
        {
          command = lib.getExe pkgs.powertop;
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/powertop";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
  services.logind.settings.Login = {
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitch = lib.mkDefault "ignore";
  };
}
