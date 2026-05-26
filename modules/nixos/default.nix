{ lib, config, ... }:
let
  mylib = import ../../lib { inherit lib; };
in
{
  _module.args.mylib = mylib;
  imports = [
    # keep-sorted start
    ../../hardening/nixpaks
    ../common
    ../common/nix-helper.nix
    ../common/sops.nix
    ../common/styles
    ../common/styles/nixos.nix
    ../common/system.nix
    ../options
    ./compat.nix
    ./core
    ./hardware
    ./programs/chromium.nix
    ./programs/dolphin.nix
    ./programs/firefox.nix
    ./programs/obs-studio.nix
    ./programs/rime.nix
    ./programs/steam.nix
    ./programs/thunderbird.nix
    ./programs/zsh.nix
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

  nix.settings = {
    substituters = config.nixdefs.misc.binary-cache.substituters;
    trusted-public-keys = config.nixdefs.misc.binary-cache.trusted-public-keys;
    trusted-users = [
      "root"
      config.nixdots.user.name
    ];
  };
}
