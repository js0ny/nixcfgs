{ pkgs, ... }:
{
  home.packages = with pkgs.kdePackages; [
    elisa
  ];
  js0ny.persist.stores.state = {
    files = [
      {
        file = ".config/elisarc";
        how = "symlink";
      }
    ];
    directories = [ ".local/share/elisa" ];
  };
}
