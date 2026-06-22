{ pkgs, ... }: {
  services.fwupd.enable = true;
  systemd.timers.fwupd-refresh.enable = false;
  environment.systemPackages = with pkgs; [
    gnome-firmware
  ];
}
