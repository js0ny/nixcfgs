{ config, ... }:
{
  imports = [
    # keep-sorted start
    ../common
    ../common/hm.nix
    ../common/nix-helper.nix
    ../common/nix.nix
    ../common/sops.nix
    ../common/styles
    ../common/styles/nixos.nix
    ../common/system.nix
    ../definitions
    ../nixpaks
    ../options
    ./compat.nix
    ./core
    ./hardware
    ./programs
    ./security/hardening.nix
    ./security/howdy.nix
    ./virtualisation
    # keep-sorted end
  ];

  networking.hostName = config.nixdots.core.hostname;

  nixpkgs.config.allowUnfree = true;

  systemd.tmpfiles.rules = [
    "L /var/lib/dbus/machine-id - - - - /etc/machine-id"
    "z /var/lib/private 0700 root root -"
  ];

  nixdots.persist.system = {
    directories = [
      {
        directory = "/var/lib/private";
        mode = "0700";
      }
    ];
  };

  # https://github.com/nix-community/stylix/issues/2334
  stylix.targets.kmscon.enable = false;
}
