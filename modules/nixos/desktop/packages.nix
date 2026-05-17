{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    f2fs-tools
    libnotify
    libva-utils
    ltrace
    mesa-demos
    openvpn
    pciutils
    smartmontools
    strace
    usbutils
    v4l-utils
    vulkan-tools
    # keep-sorted end
  ];
}
