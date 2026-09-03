{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  mod = inputs.self.nixosModules;
in
{
  system.stateVersion = "25.05";

  imports = [
    # Host-specific configs
    ./hardware-configuration.nix
    ./btrbk.nix
    ./disko.nix
    ./restic.nix
    ./vars.nix
    ./sing-box.nix
    mod.clash-verge
    mod.throne
    mod.desktop
    mod.podman
    mod.libvirt
    mod.sshd
    mod.tailscale

    mod.hyprland
    mod.niri

    mod.gaze
  ];

  home-manager.users."js0ny" = import ./home.nix;

  boot.loader.grub.enable = lib.mkForce false;

  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;

  # # Keep the internal MediaTek Bluetooth USB device awake; it can disappear from BlueZ after USB-C monitor hotplug/resume.
  # services.udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0489", ATTR{idProduct}=="e0f6", TEST=="power/control", ATTR{power/control}="on"
  # '';

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

  services.scx = {
    enable = true;
    scheduler = "scx_pandemonium";
  };

  boot.plymouth.enable = true;

  programs.labwc.enable = true;

  # localsend, TCP/UDP 53317
  programs.localsend.enable = true;

  # only open local interface
  networking.firewall.interfaces."wlp3s0" = {
    # localsend
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 ];
    # KDE Connect
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  js0ny.user.groups = [ "wireshark" ];
}
