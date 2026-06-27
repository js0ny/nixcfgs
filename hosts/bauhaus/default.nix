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
    ../../nixos
    inputs.self.nixosModules.desktop
    inputs.self.nixosModules.obs-studio
    inputs.self.nixosModules.chromium
    inputs.self.nixosModules.zsh
    inputs.self.nixosModules.fish
    inputs.self.nixosModules.rime
    inputs.self.nixosModules.steam
    inputs.self.nixosModules.firefox
    inputs.self.nixosModules.vicinae
    inputs.self.nixosModules.thunderbird
    inputs.self.nixosModules.dolphin
    inputs.self.nixosModules.core
    inputs.self.nixosModules.podman
    inputs.self.nixosModules.libvirt
    inputs.self.nixosModules.sshd
    # ../../nixos/services/hermes-agent
    inputs.self.nixosModules.sunshine
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
