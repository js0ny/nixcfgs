{config, ...}: {
  imports = [
    ./compat.nix
    ./server

    ../options
    ../common/sops.nix
    ./sops.nix

    ./desktop
    ./hardware
    ./virtualisation

    ./core/configuration.nix
    ./core/packages.nix
    ./core/sshd.nix
    ./core/nftables.nix
    ./core/do-not-track.nix
    ./services/tailscale.nix
    ./services/syncthing.nix

    ../common/styles
    ../common/styles/nixos.nix

    ../common/impermanence/nixos.nix

    ./security/howdy.nix

    ./programs/chromium.nix
    ./programs/dolphin.nix
    ./programs/firefox.nix
    ./programs/obs-studio.nix
    ./programs/rime.nix
    ./programs/steam.nix
    ./programs/thunderbird.nix
    ./programs/zsh.nix

    ../../hardening/nixpaks
    ../common
  ];

  networking.hostName = config.nixdots.core.hostname;
}
