{ lib, config, ... }: {
  options.js0ny.host = {
    hostName = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "Hostname for the machine.";
    };
    timezones = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      example = [ "Etc/UTC" ];
      description = "Timezones for the system, the first item will be set as timezone.";
    };
    locales = {
      langcode = lib.mkOption {
        type = lib.types.str;
        default = "en_GB";
      };
      charset = lib.mkOption {
        type = lib.types.str;
        default = "UTF-8";
      };
      default = lib.mkOption {
        type = lib.types.str;
        default =
          let
            l = config.js0ny.host.locales;
          in
          "${l.langcode}.${l.charset}";
      };
      ietf = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = builtins.replaceStrings [ "_" ] [ "-" ] config.js0ny.host.locales.langcode;
      };
      guiLocale = lib.mkOption {
        type = lib.types.str;
        default = config.js0ny.host.locales.ietf;
      };
      settings = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {
          LC_ALL = config.js0ny.host.locales.default;
        };
      };
    };
    flakeDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.js0ny.user.home}/.dotfiles";
      description = "Path for flake directory.";
    };
  };
}
