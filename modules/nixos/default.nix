{ config, ... }:
{
  imports = [
    ./compat.nix

    ../options
    ../common/sops.nix
    ./sops.nix

    ./hardware
    ./virtualisation

    ./core

    ./services/tailscale.nix
    ./services/syncthing.nix

    ../common/styles
    ../common/system.nix
    ../common/styles/nixos.nix

    ../common/impermanence/nixos.nix

    ./security/howdy.nix
    ./security/apparmor.nix

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

  systemd.tmpfiles.rules = [
    "L /var/lib/dbus/machine-id - - - - /etc/machine-id"
  ];
}
