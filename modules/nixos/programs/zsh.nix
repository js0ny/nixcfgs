{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.programs.zsh.enable;
in
lib.mkIf cfg {
  programs.zsh = {
    enable = true;
    histFile = "$XDG_DATA_HOME/zsh/history";
    enableCompletion = true;
    zsh-autoenv.enable = true;
    autosuggestions.enable = true;
  };
  environment.pathsToLink = [ "/share/zsh" ];
}
