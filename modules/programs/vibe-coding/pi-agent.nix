{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    llm-agents.pi
  ];
  home.sessionVariables = {
    PI_CODING_AGENT_SESSION_DIR = "${config.xdg.dataHome}/pi/agent/session";
    PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi/agent";
  };
  nixdots.persist.home.directories = [ ".config/pi/agent" ];
}
