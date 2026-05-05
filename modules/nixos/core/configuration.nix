{
  config,
  pkgs,
  lib,
  ...
}:
let
  username = config.nixdots.user.name;
  sysShell = config.nixdots.user.shell;
  sshKeys = config.nixdefs.misc.ssh.sshKeys;
in
{
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
    "/var/log"
    "/var/lib/nixos"
    "/var/lib/systemd/coredump"
  ];

  environment.sessionVariables = {
    # Default value: FRSXMK, where S indicates "Chops long lines"
    SYSTEMD_LESS = "FRXMK";
  };

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
}
