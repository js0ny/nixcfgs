{
  config,
  pkgs,
  ...
}:
let
  username = config.nixdots.user.name;
  sysShell = config.nixdots.user.shell;
  sshKeys = config.nixdots.user.sshKeys;
in
{
  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocales = [
      "en_GB.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      # LC_CTYPE = "en_GB.UTF-8";
      LC_ALL = "en_GB.UTF-8";
    };
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
}
