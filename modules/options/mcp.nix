# References
#
# ClientConfig:
# * Codex: https://learn.chatgpt.com/docs/extend/mcp
# * Hermes Agent: https://hermes-agent.nousresearch.com/docs/reference/mcp-config-reference/
# * Pi: https://pi.dev/docs/latest/mcp
# * OMP: https://github.com/can1357/oh-my-pi/blob/main/docs/mcp-config.md
{
  pkgs,
  lib,
  secrets,
  config,
  options,
  ...
}:
let
  cfg = config.js0ny.mcp;
  selectServers =
    categories: excludedTags:
    lib.filterAttrs (
      _: server:
      server.enable
      && builtins.elem server.category categories
      && !(lib.any (tag: builtins.elem tag excludedTags) server.tags)
    ) cfg.servers;
  clientServers =
    client: categories: excludedTags:
    lib.mapAttrs (
      _: server:
      let
        settings =
          if client == "codex" && server.type == "streamable-http" then
            removeAttrs server.server [ "headers" ]
            // lib.optionalAttrs (server.server ? headers) {
              http_headers = server.server.headers;
            }
          else if client == "omp" then
            server.server // { type = if server.type == "stdio" then "stdio" else "http"; }
          else
            server.server;
      in
      lib.recursiveUpdate settings (server.clientConfig.${client} or { })
    ) (selectServers categories excludedTags);
  mcpType = lib.types.submodule {
    options = {
      enable = lib.mkEnableOption "Enable this mcp server";
      server = lib.mkOption { type = lib.types.attrs; };
      clientConfig = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "Per-client server settings, recursively merged over the generated transport settings.";
      };
      type = lib.mkOption {
        type = lib.types.enum [
          "stdio"
          "streamable-http"
        ];
      };
      category = lib.mkOption {
        type = lib.types.enum [
          "common"
          "code"
          "work"
        ];
        default = "common";
      };
      tags = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
      };
    };
  };
in
{
  options.js0ny.mcp = {
    servers = lib.mkOption {
      type = lib.types.attrsOf mcpType;
      default = { };
    };
    clientSettings = lib.mkOption {
      type = lib.types.attrs;
      readOnly = true;
      description = ''
        Generated Codex and Hermes mcp_servers settings and Pi and OMP mcpServers settings.
        Pi and OMP include enabled common and code servers. Codex and Hermes also include
        work servers. Codex, Hermes and OMP exclude servers tagged search-common.
        Per-server clientConfig overrides are applied after transport conversion.
        Servers use either stdio or streamable-http transport.
      '';
    };
  };
  config =
    let
      sopsFile = secrets + "/mcp.yaml";
      secretSettings = {
        inherit sopsFile;
        mode = "0440";
      }
      // lib.optionalAttrs (options ? users.groups && options ? systemd) {
        group = "agents";
      };
    in
    {
      sops.secrets = {
        context7_api_key = secretSettings;
        firecrawl_api_key = secretSettings;
        tavily_api_key = secretSettings;
        grafana_mcp_api_key = secretSettings;
        exa_api_key = secretSettings;
      };
      js0ny.mcp.servers = {
        context7 = {
          enable = true;
          type = "stdio";
          category = "code";
          tags = [ "docs" ];
          server.command = lib.getExe (
            pkgs.writeShellScriptBin "context7-mcp" /* bash */ ''
              secret_file="${config.sops.secrets.context7_api_key.path}"
              export CONTEXT7_API_KEY="$(${lib.getExe' pkgs.coreutils "cat"} "$secret_file")"
              export CTX7_TELEMETRY_DISABLED=1

              exec ${lib.getExe' pkgs.nodejs "npx"} -y @upstash/context7-mcp
            ''
          );
        };
        deepwiki = {
          enable = false;
          type = "streamable-http";
          category = "code";
          tags = [ "docs" ];
          server.url = "https://mcp.deepwiki.com/mcp";
        };
        mdn = {
          enable = true;
          type = "streamable-http";
          category = "code";
          tags = [ "docs" ];
          server.url = "https://mcp.mdn.mozilla.net/";
        };
        nixos = {
          enable = true;
          type = "stdio";
          category = "code";
          tags = [ "docs" ];
          server.command = lib.getExe pkgs.mcp-nixos;
        };
        ghgrep = {
          enable = false;
          type = "streamable-http";
          category = "code";
          tags = [ "search-code" ];
          server.url = "https://mcp.grep.app";
        };
        tavily = {
          enable = true;
          type = "stdio";
          category = "common";
          tags = [ "search-common" ];
          server.command = lib.getExe (
            pkgs.writeShellScriptBin "mcp-tavily" /* bash */ ''
              export TAVILY_API_KEY="$(${lib.getExe' pkgs.coreutils "cat"} "${config.sops.secrets.tavily_api_key.path}")"
              exec ${lib.getExe' pkgs.nodejs "npx"} -y tavily-mcp
            ''
          );
        };
        firecrawl = {
          enable = true;
          type = "stdio";
          category = "common";
          tags = [ "crawler" ];
          server.command = lib.getExe (
            pkgs.writeShellScriptBin "mcp-firecrawl" /* bash */ ''
              export FIRECRAWL_API_KEY="$(${lib.getExe' pkgs.coreutils "cat"} "${config.sops.secrets.firecrawl_api_key.path}")"
              exec ${lib.getExe' pkgs.nodejs "npx"} -y firecrawl-mcp
            ''
          );
          clientConfig = {
            pi.exposure = "deferred";
          };
        };
        exa = {
          enable = true;
          type = "stdio";
          category = "common";
          tags = [ "search-common" ];
          server.command = lib.getExe (
            pkgs.writeShellScriptBin "mcp-exa" /* bash */ ''
              exec ${lib.getExe pkgs.mcp-proxy} \
                -H Authorization "Bearer $(${lib.getExe' pkgs.coreutils "cat"} "${config.sops.secrets.exa_api_key.path}")" \
                --transport streamablehttp \
                "https://mcp.exa.ai/mcp?tools=web_search_exa,web_fetch_exa,web_search_advanced_exa"
            ''
          );
          clientConfig = {
            pi.exposure = "hidden";
          };
        };
        grafana = {
          enable = true;
          type = "stdio";
          category = "code";
          tags = [ "devops" ];
          server = {
            command = lib.getExe pkgs.js0ny.mcp-grafana;
            env = {
              GRAFANA_SERVICE_ACCOUNT_TOKEN_FILE = config.sops.secrets.grafana_mcp_api_key.path;
              GRAFANA_URL = config.nixdefs.endpoints.grafana.publicUrl;
            };
          };
          clientConfig = {
            codex.default_tools_approval_mode = "writes";
            hermes.trust = "untrusted";
            pi.exposure = "deferred";
          };
        };
      };
      js0ny.mcp.clientSettings = {
        # clientServers: String -> List -> List -> Attrs
        # client: categories: excludedTags:
        codex.mcp_servers = clientServers "codex" [ "common" "code" "work" ] [ "search-common" ];
        hermes.mcp_servers = clientServers "hermes" [ "common" "code" "work" ] [ "search-common" ];
        pi.mcpServers = clientServers "pi" [ "common" "code" ] [ ];
        omp.mcpServers = clientServers "omp" [ "common" "code" ] [ "search-common" ];
      };
    }
    // lib.optionalAttrs (options ? users.groups && options ? systemd) {
      users.groups.agents = { };
    };
}
