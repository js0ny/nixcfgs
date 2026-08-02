{
  pkgs,
  config,
  secrets,
  ...
}:
let
  ep = config.nixdefs.endpoints;
in
{
  home.packages = with pkgs; [ js0ny.ratune ];
  sops.secrets = {
    navidrome_my_password = {
      sopsFile = secrets + /navidrome.yaml;
    };
  };
  xdg.configFile."ratune/config.toml".source = pkgs.writers.writeTOML "ratune-config.toml" {
    server = {
      url = ep.navidrome.publicUrl;
      username = "js0ny";
      password_command = "cat ${config.sops.secrets.navidrome_my_password.path}";
    };
    player = {
      default_volume = 70;
      max_bit_rate = 0;
      mpris = pkgs.stdenv.isLinux;
    };
    lyrics.source = "lrclib";
    ratings.enabled = true;
    theme.preset = "dynamic";
    cache = {
      enabled = true;
      max_size_gb = 2;
    };
  };
}
