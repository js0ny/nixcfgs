{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkMerge [
  {
    programs.anki = {
      enable = true;
      profiles."User 1".sync = {
        autoSync = true;
        autoSyncMediaMinutes = 15;
      };
    };
  }
  (lib.mkIf pkgs.stdenv.isDarwin {
    programs.anki = {
      package = pkgs.anki-bin;
      addons = [ ];
    };
    stylix.targets.anki.enable = false;
  })
  (lib.mkIf pkgs.stdenv.isLinux {
    programs.anki = {
      package = pkgs.anki;
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
  })
]
