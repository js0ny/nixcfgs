{ pkgs, ... }:
{
  home.packages = [
    pkgs.bruno
    pkgs.bruno-cli
  ];
  nixdots.persist.home = {
    directories = [
      ".config/bruno"
    ];
  };
}
