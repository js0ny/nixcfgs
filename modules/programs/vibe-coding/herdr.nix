{ config, pkgs, ... }: {
  programs.herdr.enable = true;
  programs.codex.hooks = {
    SessionStart = [
      {
        hooks = [
          {
            type = "command";
            command = "bash '${config.xdg.configHome}/codex/herdr-agent-state.sh' session";
            timeout = 10;
          }
        ];
      }
    ];
  };
  xdg.configFile."codex/herdr-agent-state.sh".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/herdrdev/herdr/refs/tags/v${config.programs.herdr.package.version}/src/integration/assets/codex/herdr-agent-state.sh";
    hash = "sha256-KsgRU1n/hJzWHkUFdLNx9nMngKY6B62HwARI21wgNi0=";
  };
}
