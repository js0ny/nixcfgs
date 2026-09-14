{
  pkgs,
  lib,
  config,
  secrets,
  ...
}:
let
  username = config.js0ny.user.name;
  sysShell = config.js0ny.user.shell;
  sshKeys = config.nixdefs.misc.ssh.sshKeys;
in
{
  imports = [
    "${secrets}/nixos/passwd.nix"
    ../../definitions
    ../../modules/options
  ];
  time.timeZone = builtins.head config.js0ny.host.timezones;
  networking.hostName = config.js0ny.host.hostName;

  nixpkgs.config = {
    jetbrains.vmopts = "-Dawt.toolkit.name=WLToolkit";
    allowUnfree = true;
    permittedInsecurePackages = [
      "pnpm-10.29.2" # Cherry Studio
      "electron-40.10.5"
      "electron-41.10.6"
    ];
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/dbus/machine-id - - - - /etc/machine-id"
    "z /var/lib/private 0700 root root -"
  ];
  js0ny.persist.stores = {
    state = {
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
          how = "symlink";
          configureParent = true;
        }
      ];
      directories = [
        {
          directory = "/var/lib/private";
          mode = "0700";
          user = "root";
          group = "root";
        }
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
          mode = "0755";
          user = "root";
          group = "root";
        }
      ];
    };
    local = {
      directories = [
        "/var/log"
        "/var/lib/systemd/coredump"
      ];
    };
  };

  # 通过去掉 suppressedSystemUnits 修复了上游文档示例自相矛盾的问题
  # 参考： https://github.com/nix-community/preservation/issues/29
  # adapt the stock service to commit the transient ID to the persistent volume
  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/persist/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /persist"
    ];
  };

  # Select internationalisation properties.
  i18n =
    let
      locales = config.js0ny.host.locales;
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
    extraGroups = [ "wheel" ] ++ config.js0ny.user.groups;
    openssh.authorizedKeys.keys = sshKeys;
    shell = sysShell;
  };
  # Obsolete
  programs.command-not-found.enable = false;

  # provides `/bin/bash` compatibility
  services.envfs.enable = true;

  users.users.root.shell = lib.getExe pkgs.zsh;

  environment.variables = import ./shared/do-not-track-vars.nix;
  environment.localBinInPath = true;

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  services.redis.package = lib.mkDefault pkgs.valkey;
}
