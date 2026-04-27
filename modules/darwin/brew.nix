{ config, ... }:
let
  brew = config.nixdots.darwin.homebrew;
  u = config.nixdots.user.name;
  hm = config.home-manager.users."${u}".nixdots.darwin.homebrew;
in
{
  homebrew = {
    enable = brew.enable;
    # Get it via `brew --prefix`
    prefix = brew.prefix;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    brews = brew.formulae ++ hm.formulae;
    casks = brew.casks ++ hm.casks;
  };

  nixdots.darwin.homebrew = {
    enable = true;
    taps = [
      "js0ny/tap"
    ];
    formulae = [
      "coreutils"
      "folderify"
    ];
  };
}
