{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nixdots.machine.virtualisation.waydroid;
in
lib.mkIf cfg {
  virtualisation.waydroid.enable = true;
  # waydroid-script: Tool to install libhoudini (arm support), magisk, ...
  # usage: sudo waydroid-script
  environment.systemPackages = with pkgs; [
    pkgs.nur.repos.ataraxiasjel.waydroid-script
    waydroid-helper
  ];

  networking = {
    firewall.trustedInterfaces = [ "waydroid0" ];
    nat.enable = true;
  };

  systemd = {
    packages = [ pkgs.waydroid-helper ];
    services.waydroid-mount = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.waydroid-helper} --start-mount";
      };
    };
  };
}
