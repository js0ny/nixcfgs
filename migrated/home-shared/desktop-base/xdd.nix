{
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.js0ny.xdd ];
  xdg.configFile."xdd/config.toml".source = pkgs.writers.writeTOML "xdd-config" {
    roots = {
      atelier = "~/Atelier";
      projects = "~/Atelier/prj";
      pcloud = "~/.sandbox/.per-app/pcloud/pCloudDrive";
      academia = "~/Academia";
    };
  };
}
