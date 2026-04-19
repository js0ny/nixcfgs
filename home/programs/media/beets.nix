{ pkgs, ... }:
{
  home.packages = with pkgs; [ beets ];
  # TODO: Migrate config to nix.
  programs.beets = {
    enable = false;
    settings = {
      plugins = [ "rewrite" ];
    };
  };
  nixdots.persist.home = {
    directories = [
      ".local/share/beets"
    ];
  };
}
