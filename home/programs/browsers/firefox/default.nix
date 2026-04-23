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
    ./policies.nix
  ];

  config = lib.mkIf cfg {
    programs.firefox = {
      enable = true;
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
