{
  flake.homeModules.tty7 =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.js0ny.tty7-src ];
      js0ny.persist.stores.local.directories = [ ".config/tty7" ];
    };
}
