{ lib, config, ... }:
let
  llm = config.nixdefs.llm;
  enabledAcps = lib.filterAttrs (name: server: server.enable) config.nixdefs.acp.servers;
  acpToZed =
    (builtins.mapAttrs (name: server: (removeAttrs server [ "enable" ]) // { type = "custom"; }))
      enabledAcps;
in
lib.mkMerge [
  {
    programs.zed-editor = {
      userSettings = {
        load_direnv = if config.programs.direnv.enable then "direct" else "disabled";
        terminal = {
          env.EDITOR = "zeditor";
          shell.program = config.nixdots.apps.interactiveShell.exe;
        };
      };
    };
  }
  (lib.mkIf config.nixdefs.acp.enable {
    programs.zed-editor = {
      userSettings.agent_servers = acpToZed;
    };
  })
  (lib.mkIf config.nixdefs.mcp.enable {
    programs.zed-editor = {
      userSettings.context_servers = config.nixdefs.mcp.clientConfigs.zed-editor;
    };
  })
  # TODO: [AFTER] model details for custom providers since tokens and capabilities are required by zed.
  # (lib.mkIf llm.enable {
  #   programs.zed-editor.userSettings = {
  #     agent = {
  #       default_model = {
  #         provider = llm.routing.code-plan.provider;
  #         model = llm.routing.code-plan.model;
  #       };
  #     };
  #   };
  # })
]
