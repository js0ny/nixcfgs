{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  system.stateVersion = "26.11";

  imports = [
    # Host-specific configs
    ./hardware-configuration.nix
    ./disko.nix
    ./vars.nix
    ./btrbk.nix
    # ./nixos-prebuild.nix
    ../../nixos/desktop
    # ../../nixos/services/hermes-agent
    ../../nixos/services/sunshine.nix
  ];

  home-manager.users."js0ny" = import ./home.nix;

  boot.loader.grub.enable = lib.mkForce false;

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v4;

  stylix.image = inputs.bindeps + "/wallpaper/2.jpg";

  programs.fish.enable = true;

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };
}
