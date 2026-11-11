{
  pkgs,
  lib,
  config,
  ...
}:
let
  shell = config.js0ny.apps.interactiveShell.package;
in
{
  # https://github.com/herdrdev/herdr-core/blob/master/crates/herdr-core/src/config.rs
  xdg.configFile."herdr-core/config.toml".source = pkgs.writers.writeTOML "herdr-core-config.toml" {
    /*nixfmt:disable*/
    shell = [ (lib.getExe shell) ];
    /*nixfmt:enable*/
  };
}
