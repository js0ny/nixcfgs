{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.anki = {
    enable = pkgs.stdenv.isLinux;
    profiles."User 1".sync = {
      autoSync = true;
      autoSyncMediaMinutes = 15;
    };
    addons = with pkgs.ankiAddons; [
      anki-connect
      review-heatmap
      # recolor # Use stylix
    ];
  };
  nixdots.persist.home = {
    directories = [
      ".local/share/Anki2"
    ];
  };
  nixdots.darwin.homebrew.casks = [ "anki" ];
}
