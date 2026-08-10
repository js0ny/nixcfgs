{
  pkgs,
  lib,
  config,
  ...
}:
let
  pibase = pkgs.llm-agents.pi;
  pi = pkgs.symlinkJoin {
    name = "pi-env";
    paths = [ pibase ];
    meta = pibase.meta // {
      mainProgram = "pi";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    /*nixfmt:disable*/
    postBuild = ''
      wrapProgram "$out/bin/pi" \
        --prefix PATH : ${ lib.makeBinPath [ pkgs.python3 pkgs.nodejs ] } \
        --set PI_CODING_AGENT_SESSION_DIR "${config.xdg.dataHome}/pi/agent/session" \
        --set PI_CODING_AGENT_DIR "${config.xdg.configHome}/pi/agent"
    '';
    /*nixfmt:enable*/
  };

in
{
  home.packages = [ pi ];
  nixdots.persist.home.directories = [ ".config/pi/agent" ];
}
