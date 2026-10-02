{ pkgs, config, ... }: {
  home.packages = [ pkgs.llm-agents.ccusage ];
  js0ny.persist.stores.state.directories = [ ".config/claude" ];
  xdg.configFile."claude/ccusage.json".text = builtins.toJSON {
    "$schema" = "https://ccusage.com/config-schema.json";
    defaults = {
      breakdown = true;
      timezone = "UTC";
    };
    pi = {
      stores = [
        {
          name = "pi-agent";
          path = "${config.xdg.dataHome}/pi/agent/session";
        }
        {
          name = "omp";
          path = "${config.xdg.dataHome}/omp/agent/session";
        }
      ];
    };
  };
}
