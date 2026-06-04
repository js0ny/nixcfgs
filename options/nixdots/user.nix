{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.nixdots.user = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "pangu";
      description = "Primary user account name.";
    };
    home = lib.mkOption {
      type = lib.types.str;
      default =
        if pkgs.stdenv.isDarwin then
          "/Users/${config.nixdots.user.name}"
        else
          "/home/${config.nixdots.user.name}";
      description = "Primary user home directory.";
    };
    shell = lib.mkOption {
      type = lib.types.package;
      default = pkgs.bash;
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
      apply = lib.unique;
      description = "Extra groups for primary user.";
    };
  };
}
