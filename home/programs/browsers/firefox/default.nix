# Run nightly:
# nix run "github:nix-community/flake-firefox-nightly#firefox-nightly-bin"
{
  config,
  lib,
  ...
}:
let
  cfg = config.nixdots.programs.firefox.enable;
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  imports = [
    ./addons
    ./userjs.nix
    ./keymaps.nix
    ./search.nix
    ./betterfox.nix
    ./styles.nix
  ];

  config = lib.mkIf cfg {
    programs.firefox = {
      enable = true;
    };

    xdg.desktopEntries."firefox-private" = {
      name = "Firefox Private Window";
      genericName = "Web Browser";
      icon = "firefox-nightly";
      type = "Application";
      terminal = false;
      categories = [
        "Network"
        "WebBrowser"
      ];
      exec = "firefox --private-window %U";
    };

    # https://github.com/nix-community/stylix/issues/2071
    stylix.targets.firefox = {
      profileNames = [ "${p}" ];
      enable = false;
    };

    nixdots.persist.home = {
      directories = [
        ".mozilla"
      ];
    };
  };
}
