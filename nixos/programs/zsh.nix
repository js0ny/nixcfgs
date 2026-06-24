{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.nixdots.programs.zsh.enable;
  zsh-patina = inputs.zsh-patina.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
lib.mkIf cfg {
  programs.zsh = {
    enable = true;
    histFile = "$XDG_DATA_HOME/zsh/history";
    enableCompletion = true;
    zsh-autoenv.enable = true;
    autosuggestions = {
      enable = true;
      async = true;
    };
    interactiveShellInit = /* bash */ ''
      setopt AUTOCD
      setopt EXTENDED_GLOB        # Extended globbing

      eval "$(${lib.getExe' zsh-patina "zsh-patina"} activate)"
    '';
  };
  environment.pathsToLink = [ "/share/zsh" ];
}
