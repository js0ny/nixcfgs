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
        enable = true;
        package = pkgs.anki;
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
      js0ny.persist.stores.local.directories = [ ".local/share/Anki2" ];

      js0ny.homebrew.casks = [ "anki" ];
    };
}
