{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.desktop.enable;
in
lib.mkIf cfg {
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    v4l-utils
    f2fs-tools
    openvpn
  ];

  # Use unfree software
  nixpkgs.config.allowUnfree = true;

  services.flatpak.enable = true;
  # Disable modem
  networking.modemmanager.enable = false;
  zramSwap = {
    enable = true;
    memoryPercent = 10;
    algorithm = "lz4";
    priority = 100;
  };
}
