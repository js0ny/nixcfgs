{
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
    ./sing-box.nix
    ./strata.nix
    ./marimohub.nix
    # ./nixos-prebuild.nix
    mod.desktop
    mod.podman
    mod.libvirt
    mod.tailscale
    mod.ollama
    mod.strata
    mod.prometheus-node

    mod.tether
    mod.kdeconnect
    mod.localsend
    mod.uxplay

    mod.gnome
    mod.plasma
    mod.hyprland
    mod.niri
    mod.umbriel

    mod.localsend

    # keep-sorted start
    ../../migrated/nixos/desktop-apps/sunshine.nix
    ../../migrated/nixos/desktop-apps/virtual-desktop.nix
    ../../migrated/nixos/optional/incus
    ../../migrated/nixos/server-apps/sshd.nix
    ../../migrated/nixos/web-apps/openmausbot
    # keep-sorted end
  ];

  home-manager.users."js0ny" = import ./home.nix;

  boot.loader.grub.enable = lib.mkForce false;

  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v4;

  stylix.image = inputs.bindeps + "/wallpaper/2.jpg";

  services.ollama.loadModels = [
    "bge-m3"
    "qwen3.8:27b"
  ];

  programs.labwc.enable = true;

  # FFmpeg loads the active NVIDIA driver's CUDA and NVENC libraries at runtime.
  systemd.user.services.sunshine.environment.LD_LIBRARY_PATH = "/run/opengl-driver/lib";

}
