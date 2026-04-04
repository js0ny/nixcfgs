{
  config,
  pkgs,
  ...
}: let
  xdg-config = "${config.xdg.configHome}";
in {
  home.packages = with pkgs; [
    wakatime-cli
  ];
  home.sessionVariables = {
    WAKATIME_HOME = "${xdg-config}/wakatime"; # ~/.wakatime
  };

  sops.secrets.wakatime_api_key = {};
  sops.templates."wakatime.cfg" = {
    content = ''
      [settings]
      debug = false
      hidefilenames = false
      ignore =
          COMMIT_EDITMSG$
          PULLREQ_EDITMSG$
          MERGE_MSG$
          TAG_EDITMSG$
      exclude =
          ^COMMIT_EDITMSG$
          ^TAG_EDITMSG$
          *.md
          *.org
          *.txt
          *.log
      include =
          readme.md
          README.md
          readme.org
          README.org
          readme.txt
          README.txt
          readme
          README
      api_key= "${config.sops.placeholder.wakatime_api_key}"
    '';
    path = "${xdg-config}/wakatime/.wakatime.cfg";
  };
}
