{ pkgs, config, ... }: {
  home.packages = [ pkgs.llm-agents.ccusage ];
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
      ];
    };
  };
}
