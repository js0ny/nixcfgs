{
  config,
  pkgs,
  ...
}: let
  username = config.nixdots.user.name;
  flake = config.nixdots.core.flakeDir;
  sysShell = config.nixdots.user.shell;
  sshKeys = config.nixdots.user.sshKeys;
in {
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

  # system.copySystemConfiguration = true;
  nix.settings = {
    trusted-users = ["${username}" "root"];
    use-xdg-base-directories = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
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

  programs.nh = {
    enable = true;
    flake = flake;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 3d";
    };
  };
}
