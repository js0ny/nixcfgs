{
  pkgs,
  lib,
  config,
  ...
}:
let
  pibase = pkgs.llm-agents.omp;
  pi = pkgs.symlinkJoin {
    name = "omp-env";
    paths = [ pibase ];
    meta = pibase.meta // {
      mainProgram = "omp";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    /*nixfmt:disable*/
    postBuild = ''
      wrapProgram "$out/bin/omp" \
        --prefix PATH : ${ lib.makeBinPath [ pkgs.python3 pkgs.nodejs ] } \
        --set PI_CODING_AGENT_SESSION_DIR "${config.xdg.dataHome}/omp/agent/session" \
        --set PI_CODING_AGENT_DIR "${config.xdg.configHome}/omp/agent"
    '';
    /*nixfmt:enable*/
  };

in
{
  home.packages = [ pi ];
  nixdots.persist.home.directories = [ ".config/omp" ];
}
