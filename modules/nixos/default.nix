{ lib, config, ... }:
let
  mylib = import ../../lib { inherit lib; };
in
{
  _module.args.mylib = mylib;
  imports = [
    ./compat.nix

    ../options

    ./hardware
    ./virtualisation

    ./core

    ./services/tailscale.nix
    ./services/syncthing.nix
    ./services/ollama.nix

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
  ];

  networking.hostName = config.nixdots.core.hostname;

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
