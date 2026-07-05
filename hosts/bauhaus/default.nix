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
    inputs.self.nixosModules.desktop
    inputs.self.nixosModules.podman
    inputs.self.nixosModules.libvirt
    inputs.self.nixosModules.sshd
    inputs.self.nixosModules.tailscale
    # ../../nixos/services/hermes-agent
    inputs.self.nixosModules.sunshine
    inputs.self.nixosModules.ollama

    inputs.self.nixosModules.gnome
    inputs.self.nixosModules.plasma
    inputs.self.nixosModules.hyprland
    inputs.self.nixosModules.niri
  ];

  home-manager.users."js0ny" = import ./home.nix;

  boot.loader.grub.enable = lib.mkForce false;

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v4;

  stylix.image = inputs.bindeps + "/wallpaper/2.jpg";

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };
}
