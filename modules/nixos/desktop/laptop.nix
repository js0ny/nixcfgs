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
  ];
  services.upower.enable = true;
}
