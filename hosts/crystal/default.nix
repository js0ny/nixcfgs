{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  system.stateVersion = "25.05";

  imports = [
    # Host-specific configs
    ./hardware-configuration.nix
    ./disko.nix
    ./restic.nix
    ./vars.nix
    # ./nixos-prebuild.nix
    ../../nixos/desktop
    ../../nixos/services/hermes-agent
  ];

  home-manager.users."js0ny" = import ./home.nix;

  boot.loader.grub.enable = lib.mkForce false;

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;
  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;

  # Keep the internal MediaTek Bluetooth USB device awake; it can disappear from BlueZ after USB-C monitor hotplug/resume.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0489", ATTR{idProduct}=="e0f6", TEST=="power/control", ATTR{power/control}="on"
  '';

  services.libinput = {
    enable = true;
    touchpad = {
      clickMethod = "clickfinger";
      disableWhileTyping = true;
      naturalScrolling = true;
      scrollMethod = "twofinger";
      tapping = true;
      tappingButtonMap = "lrm";
    };
  };
  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x10"
  ];
  stylix.image = inputs.bindeps + "/wallpaper/2.jpg";

  programs.fish.enable = true;

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

}
