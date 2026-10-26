# https://github.com/js0ny/xdd
# Cross-platform Directory Definitions
# Use it with:
# [Repo Path](xdd://flake/migrated/home-shared/desktop-base/xdd.nix)
{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.js0ny.xdd ];
  # https://github.com/js0ny/xdd#configuration
  xdg.configFile."xdd/config.toml".source = pkgs.writers.writeTOML "xdd-config" {
    roots = {
      atelier = "~/Atelier";
      projects = "~/Atelier/prj";
      pcloud = "~/.sandbox/.per-app/pcloud/pCloudDrive";
      academia = "~/Academia";
      flake = "~/Atelier/dot/nixcfgs";
      docs = "~/Documents";
    };
  };
}
