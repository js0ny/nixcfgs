{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.laptop.asus;
in
lib.mkIf cfg {
  environment.systemPackages = with pkgs; [
    asusctl
    supergfxctl
  ];

  services.asusd.enable = true;
  services.supergfxd.enable = true;

  environment.etc."asusd/slash.ron".text = ''
    (
        enabled: true,
        brightness: 255,
        display_interval: 0,
        display_mode: Bounce,
        show_on_boot: true,
        show_on_shutdown: false,
        show_on_sleep: false,
        show_on_battery: false,
        show_battery_warning: false,
        show_on_lid_closed: true,
    )
  '';
}
