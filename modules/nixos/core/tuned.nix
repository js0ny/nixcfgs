{ lib, config, ... }:
{
  services.tlp.enable = lib.mkForce false;
  services.power-profiles-daemon.enable = lib.mkForce false;

  services.tuned = {
    enable = !config.nixdots.linux.wsl;
    ppdSupport = true; # Analogous to power-profiles-daemon support, but for tuned
  };

  nixdots.persist.system = {
    directories = [
      "/etc/tuned"
    ];
  };
}
