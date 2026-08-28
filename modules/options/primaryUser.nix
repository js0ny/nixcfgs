{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.js0ny.user = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "js0ny";
      description = "Primary user account name.";
    };
    home = lib.mkOption {
      type = lib.types.str;
      default =
        if pkgs.stdenv.hostPlatform.isDarwin then
          "/Users/${config.js0ny.user.name}"
        else
          "/home/${config.js0ny.user.name}";
      description = "Primary user home directory.";
    };
    shell = lib.mkOption {
      type = lib.types.package;
      default = pkgs.zsh;
      description = "Default / Login Shell for user.";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "me@example.com";
    };
    avatar = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    groups = lib.mkOption {
      type = with lib.types; listOf str;
      apply = lib.uniqueStrings;
      description = "Extra groups for primary user.";
    };
  };
}
