{lib, ...}: {
  services.tlp.enable = lib.mkForce false;
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.upower.enable = true;

  services.tuned = {
    enable = true;
    ppdSupport = true; # Analogous to power-profiles-daemon support, but for tuned
  };

  nixdots.persist.system = {
    directories = [
      "/etc/tuned"
    ];
  };
}
