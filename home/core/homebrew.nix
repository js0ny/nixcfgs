{
  pkgs,
  lib,
  config,
  ...
}:
let
  darwin = config.nixdots.darwin;
  brew = darwin.homebrew;
in
lib.mkIf (darwin.enable && brew.enable) {

  misc.shellAliases = {
    brewi = "brew install";
    brewr = "brew remove";
    brewu = "brew upgrade && brew update";
    brewc = "brew cleanup";
    brewl = "brew list";
  };

  home.sessionPath = [ "${brew.prefix}/bin" ];

  home.sessionVariables = {
    HOMEBREW_NO_AUTO_UPDATE = 1;
    HOMEBREW_NO_ENV_HINTS = 1;
  };
}
