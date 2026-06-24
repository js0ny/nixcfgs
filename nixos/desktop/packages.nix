{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    ddcutil # requires i2c enabled
    efibootmgr
    f2fs-tools
    gnome-firmware
    libnotify
    libva-utils
    lm_sensors
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
    # keep-sorted end
  ];
  programs.gnome-disks.enable = true;
}
