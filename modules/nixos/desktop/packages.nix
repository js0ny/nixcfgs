{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    efibootmgr
    f2fs-tools
    libnotify
    libva-utils
    ltrace
    mesa-demos
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
}
