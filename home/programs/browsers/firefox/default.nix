{ config, ... }:
let
  p = config.nixdots.programs.firefox.defaultProfile;
in
{
  imports = [
    ./betterfox.nix
    ./addons
    ./keymaps.nix
    ./search.nix
    ./styles.nix
  ];
  # Upstream: https://github.com/nix-community/stylix/issues/2071
  stylix.targets.firefox = {
    profileNames = [ "${p}" ];
    enable = false;
  };
}
