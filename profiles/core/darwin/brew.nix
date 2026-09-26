{ config, lib, ... }:
let
  cfg = config.js0ny.homebrew;
  primaryUser = config.js0ny.user.name;
  homeConfig = config.home-manager.users."${primaryUser}".js0ny.homebrew;
in
lib.mkIf cfg.enable {
  homebrew = {
    enable = cfg.enable;
    # Get it via `brew --prefix`
    prefix = cfg.prefix;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    brews = cfg.formulae ++ homeConfig.formulae;
    casks = cfg.casks ++ homeConfig.casks;
  };

  js0ny.homebrew.taps = [ "js0ny/tap" ];

  programs.fish.interactiveShellInit = /* fish */ ''
    if test -d "${cfg.prefix}/share/fish/completions"
        set -p fish_complete_path ${cfg.prefix}/share/fish/completions
    end

    if test -d "${cfg.prefix}/share/fish/vendor_completions.d"
        set -p fish_complete_path ${cfg.prefix}/share/fish/vendor_completions.d
    end
  '';
}
