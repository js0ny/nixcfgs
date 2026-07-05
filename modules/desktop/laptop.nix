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
  ];

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
  services.upower.ignoreLid = lib.mkDefault true;
  services.logind.settings.Login = {
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitch = lib.mkDefault "ignore";
  };
}
