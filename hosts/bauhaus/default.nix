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
  system.stateVersion = "26.11";

  imports = [
    # Host-specific configs
    ./hardware-configuration.nix
    ./disko.nix
    ./vars.nix
    ./btrbk.nix
    ./dae-wireguard.nix
    # ./nixos-prebuild.nix
    mod.desktop
    mod.podman
    mod.libvirt
    mod.sshd
    mod.tailscale
    # ../../nixos/services/hermes-agent
    mod.sunshine
    mod.ollama

    mod.wireguard

    mod.gnome
    mod.plasma
    mod.hyprland
    mod.niri
    mod.cosmic
  ];

  home-manager.users."js0ny" = import ./home.nix;

  boot.loader.grub.enable = lib.mkForce false;

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v4;

  stylix.image = inputs.bindeps + "/wallpaper/2.jpg";

  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };
  programs.labwc.enable = true;
}
