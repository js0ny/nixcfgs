{
  flake.homeModules.qutebrowser =
    { pkgs, config, ... }:
    let
      # BUG presents with nvidia gpu on qtwebengine
      qb = pkgs.runCommand "qutebrowser-wrapped" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
        mkdir -p $out/bin
        makeWrapper ${pkgs.qutebrowser}/bin/qutebrowser $out/bin/qutebrowser \
          --set QT_QUICK_BACKEND "software"
      '';
    in
    {
      programs.qutebrowser = {
        enable = config.nixdots.linux.display != "none";
        package = if (config.nixdots.linux.gpu == "nvidia") then qb else pkgs.qutebrowser;
        searchEngines = {
          g = "https://www.google.com/search?hl=en&q={}";
        };
      };
      xdg.dataFile."qutebrowser/greasemonkey" = {
        recursive = true;
        source = ./greasemonkey;
      };
    };
}
