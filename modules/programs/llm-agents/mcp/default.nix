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
      sopsFile = secrets + /mcp.yaml;
      context7-mcp = pkgs.writeShellApplication {
        name = "context7-mcp";

        runtimeInputs = [
          pkgs.coreutils
          pkgs.nodejs_26
        ];

        text = ''
          secret_file="${config.sops.secrets.context7_api_key.path}"

          if [ ! -r "$secret_file" ]; then
            echo "context7-mcp: cannot read Context7 API key at $secret_file" >&2
            exit 1
          fi

          CONTEXT7_API_KEY="$(cat "$secret_file")"
          export CONTEXT7_API_KEY

          export CTX7_TELEMETRY_DISABLED=1

          exec npx -y @upstash/context7-mcp
        '';
      };
      tavily-mcp = pkgs.writeShellApplication {
        name = "tavily-mcp";

        runtimeInputs = [
          pkgs.coreutils
          pkgs.nodejs_26
        ];

        text = ''
          secret_file="${config.sops.secrets.tavily_api_key.path}"

          if [ ! -r "$secret_file" ]; then
            echo "tavily-mcp: cannot read tavily API key at $secret_file" >&2
            exit 1
          fi

          TAVILY_API_KEY="$(cat "$secret_file")"
          export TAVILY_API_KEY

          exec npx -y tavily-mcp@0.1.3
        '';
      };
    in
    {
      sops.secrets = {
        context7_api_key = { inherit sopsFile; };
        tavily_api_key = { inherit sopsFile; };
      };

      home.file.".pi/agent/mcp.json".text = builtins.toJSON {
        mcpServers = {
          context7.command = lib.getExe context7-mcp;
          deepwiki.url = "https://mcp.deepwiki.com/mcp";
          ghgrep.url = "https://mcp.grep.app";
          nixos.command = lib.getExe pkgs.mcp-nixos;
          tavily.command = lib.getExe tavily-mcp;
        };
      };
    };

  flake.homeModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.homeModules.mcp ];
  };
}
