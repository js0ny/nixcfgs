{
  flake.homeModules.anki =
    {
      pkgs,
      lib,
      config,
      secrets,
      ...
    }:
    {
      sops.secrets = {
        anki_sync_key = {
          sopsFile = secrets + "/hosts.yaml";
        };
      };
      programs.anki = {
        enable = false;
        profiles."User 1".sync = {
          username = "ankiweb.unusable450@passmail.net";
          keyFile = config.sops.secrets.anki_sync_key.path;
          autoSync = true;
          autoSyncMediaMinutes = 15;
        };
        addons = with pkgs.ankiAddons; [
          anki-connect
          review-heatmap
          # recolor # Use stylix
        ];
      };
      nixdots.persist.nosnap.home.directories = [
        ".local/share/Anki2"
      ];

      js0ny.homebrew.casks = [ "anki" ];
      js0ny.flatpak.packages = [ "net.ankiweb.Anki" ];
    };
}
