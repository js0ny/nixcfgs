{ config, lib, ... }:
let
  cfg = config.nixdots.js0ny.homebrew;
  u = config.nixdots.user.name;
  hm = config.home-manager.users."${u}".nixdots.js0ny.homebrew;
in
lib.mkIf cfg.enable {
  homebrew = {
    enable = cfg.enable;
    # Get it via `brew --prefix`
    prefix = "/opt/homebrew";
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    brews = cfg.formulae ++ hm.formulae;
    casks = cfg.casks ++ hm.casks;
  };

  nixdots.js0ny.homebrew = {
    taps = [ "js0ny/tap" ];
  };

  programs.fish.interactiveShellInit = /* fish */ ''
    if test -d "${cfg.prefix}/share/fish/completions"
        set -p fish_complete_path ${cfg.prefix}/share/fish/completions
    end

    if test -d "${cfg.prefix}/share/fish/vendor_completions.d"
        set -p fish_complete_path ${cfg.prefix}/share/fish/vendor_completions.d
    end
  '';
}
