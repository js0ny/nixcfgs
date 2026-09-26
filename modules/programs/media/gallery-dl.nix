{
  pkgs,
  lib,
  config,
  secrets,
  ...
}:
let
  galleryDlWrapper = pkgs.writeShellApplication {
    name = "gallery-dl";
    # This will deeply merge with `config.programs.gallery-dl.settings`
    text = /* bash */ ''
      exec ${lib.getExe config.programs.gallery-dl.package} \
        --config-json ${config.sops.templates."gdl-extra.json".path} \
        "$@"
    '';
  };
in
{
  programs.gallery-dl = {
    enable = true;
    settings = {
      extractor = {
        base-directory = lib.mkDefault config.xdg.userDirs.download;
      };
    };
  };
  xdg.configFile."gallery-dl/config.json".force = true;
  # https://gdl-org.github.io/docs/gallery-dl.conf
  sops.templates."gdl-extra.json" = {
    content = /* json */ ''
      {
        "extractor": {
          "pixiv": {
            "refresh-token": "${config.sops.placeholder.gdl_pixiv_refresh_token}"
          }
        }
      }
    '';
    mode = "0400";
  };
  sops.secrets."gdl_pixiv_refresh_token" = {
    sopsFile = secrets + "/gallery-dl.yaml";
  };
  home.packages = [ (lib.hiPrio galleryDlWrapper) ];
  js0ny.persist.stores.state.files = [
    {
      file = ".cache/gallery-dl/cache.sqlite3";
      mode = "0600";
      how = "symlink";
    }
  ];
}
