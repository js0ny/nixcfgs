{
  pkgs,
  lib,
  config,
  secrets,
  ...
}:
let
  username = config.nixdots.user.name;
  sysShell = config.nixdots.user.shell;
  sshKeys = config.nixdefs.misc.ssh.sshKeys;
in
{
  # TODO: Use scanPaths
  imports = [
    "${secrets}/nixos/passwd.nix"
    ./nix-helper.nix
    ./nix.nix
    ./nixos/compat-tools.nix
    ./nixos/impermanence.nix
    ./nixos/kernel-hardening.nix
    ./nixos/sops.nix
    ./nixos/styles.nix
    ./nixos/tuned.nix
  ];
  time.timeZone = builtins.head config.nixdots.core.timezones;

  # Select internationalisation properties.
  i18n =
    let
      locales = config.nixdots.core.locales;
    in
    {
      defaultLocale = locales.default;
      defaultCharset = locales.charset;
      extraLocales = [
        "en_GB.UTF-8/UTF-8"
      ];
      extraLocaleSettings = locales.settings;
    };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = sshKeys;
    shell = sysShell;
  };
  # Obsolete
  programs.command-not-found.enable = false;

  nixdots.persist.system.files = [
    "/etc/machine-id"
  ];

  nixdots.persist.system.directories = [
    "/var/lib/nixos"
  ];

  nixdots.persist.nosnap.system.directories = [
    "/var/log"
    "/var/lib/systemd/coredump"
  ];

  # provides `/bin/bash` compatibility
  services.envfs.enable = true;

  users.users.root.shell = lib.getExe pkgs.zsh;

  environment.variables = import ./do-not-track-vars.nix;
  environment.sessionVariables = {
    # Default value: FRSXMK, where S indicates "Chops long lines"
    SYSTEMD_LESS = "FRXMK";
  };

  environment.localBinInPath = true;

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  security.sudo.enable = false;
  security.sudo-rs = {
    enable = true;
    extraConfig = ''
      Defaults lecture = never
    '';
    execWheelOnly = true;
  };

  networking.nftables = {
    enable = true;
  };
  networking.firewall.backend = "nftables";

  environment.systemPackages = with pkgs; [
    iptables-nftables-compat
  ];
}
