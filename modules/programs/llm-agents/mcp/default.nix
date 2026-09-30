{
  flake.homeModules.mcp =
    {
      pkgs,
      lib,
      config,
      secrets,
      ...
    }:
    let
      nodejs = pkgs.nodejs_26;
      context7-mcp = pkgs.callPackage ./pkgs/context7-mcp.nix {
        inherit nodejs;
        apiKeyPath = config.sops.secrets.context7_api_key.path;
      };
      tavily-mcp = pkgs.callPackage ./pkgs/tavily-mcp.nix {
        inherit nodejs;
        apiKeyPath = config.sops.secrets.tavily_api_key.path;
      };
      sopsFile = secrets + "/mcp.yaml";
      mcpAttr = {
        context7.command = lib.getExe context7-mcp;
        nixos.command = lib.getExe pkgs.mcp-nixos;
        tavily.command = lib.getExe tavily-mcp;
        deepwiki.url = "https://mcp.deepwiki.com/mcp";
        ghgrep.url = "https://mcp.grep.app";
      };
      mcpOpenCodeConfig = {
        context7 = {
          type = "local";
          command = [ (lib.getExe context7-mcp) ];
        };
        deepwiki = {
          type = "remote";
          url = "https://mcp.deepwiki.com/mcp";
        };
        ghgrep = {
          type = "remote";
          url = "https://mcp.grep.app";
        };
        nixos = {
          type = "local";
          command = [ (lib.getExe pkgs.mcp-nixos) ];
        };
        tavily = {
          type = "local";
          command = [ (lib.getExe tavily-mcp) ];
        };
      };
      mcpVSCodeConfig = {
        context7.command = lib.getExe context7-mcp;
        nixos.command = lib.getExe pkgs.mcp-nixos;
        tavily.command = lib.getExe tavily-mcp;
        deepwiki = {
          type = "http";
          url = "https://mcp.deepwiki.com/mcp";
        };
        ghgrep = {
          type = "http";
          url = "https://mcp.grep.app";
        };
      };
      mcpZedConfig = builtins.mapAttrs (_: value: value // { enabled = true; }) mcpAttr;
    in
    {
      sops.secrets = {
        context7_api_key = { inherit sopsFile; };
        tavily_api_key = { inherit sopsFile; };
      };

      xdg.configFile."pi/agent/mcp.json".text = builtins.toJSON { mcpServers = mcpAttr; };
      xdg.configFile."omp/agent/mcp.json".text = builtins.toJSON { mcpServers = mcpAttr; };
      programs.opencode.settings.mcp.servers = mcpOpenCodeConfig;
      # Vendor harness, search builtins
      programs.codex.settings.mcp_servers = (removeAttrs mcpAttr [ "tavily" ]);

      # Editor
      programs.zed-editor.userSettings.context_servers = mcpZedConfig;
      programs.vscode.profiles.default.userMcp.servers = mcpVSCodeConfig;

    };

}
