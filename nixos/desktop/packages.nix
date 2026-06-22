{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    ddcutil # requires i2c enabled
    efibootmgr
    f2fs-tools
    libnotify
    libva-utils
    ltrace
    mesa-demos
    nvme-cli
    openvpn
    pciutils
    sbctl
    smartmontools
    strace
    usbutils
    v4l-utils
    vulkan-tools
    lm_sensors
    gnome-firmware
    # keep-sorted end
  ];
  programs.gnome-disks.enable = true;
}
