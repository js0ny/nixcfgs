{
  lib,
  config,
  ...
}:
let
  brew = config.js0ny.homebrew;
in
lib.mkIf brew.enable {

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
