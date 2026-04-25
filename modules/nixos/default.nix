{ config, ... }:
{
  imports = [
    ./compat.nix

    ../options
    ./sops.nix

    ./hardware
    ./virtualisation

    ./core

    ./services/tailscale.nix
    ./services/syncthing.nix

    ../common/sops.nix
    ../common/styles
    ../common/system.nix
    ../common/styles/nixos.nix
    ../common/nix-helper.nix

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
    ./impermanence.nix
  ];

  networking.hostName = config.nixdots.core.hostname;

  systemd.tmpfiles.rules = [
    "L /var/lib/dbus/machine-id - - - - /etc/machine-id"
  ];

  nix.settings = {
    substituters = config.nixdefs.misc.binary-cache.substituters;
    trusted-public-keys = config.nixdefs.misc.binary-cache.trusted-public-keys;
    trusted-users = [
      "root"
      config.nixdots.user.name
    ];
  };
}
