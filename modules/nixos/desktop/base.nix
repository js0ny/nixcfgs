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
  # TODO: Migrate
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
