{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nixdefs.mcp;
in
{
  options.nixdefs = {
    mcp = {
      enable = lib.mkEnableOption "Global MCP (Model Context Protocol) configuration";
      servers = lib.mkOption {
        type = lib.types.attrs;
        default = { };
      };
      clientConfigs = lib.mkOption {
        type = lib.types.attrs;
        readOnly = true;
        description = "Pre-generated configurations for various MCP clients.";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    nixdefs.mcp.servers = {
      deepwiki = {
        type = "streamable-http";
        url = "https://mcp.deepwiki.com/mcp";
        enabled = true;
        description = "Deepwiki documentation MCP";
      };
      context7 = {
        type = "streamable-http";
        url = "https://mcp.context7.com/mcp";
        headers = {
          "CONTEXT7_API_KEY" = "{env:CONTEXT7_API_KEY}";
        };
        enabled = true;
        description = "Up-to-date Docs for LLMs and AI code editors";
      };
      gh_grep = {
        type = "streamable-http";
        url = "https://mcp.grep.app";
        enabled = true;
        description = "GitHub Grep Search";
      };
      mcp-nixos = {
        type = "stdio";
        command = [
          (lib.getExe pkgs.mcp-nixos)
        ];
        enabled = true;
        description = "NixOS / Nix helper MCP";
      };
    };
    nixdefs.mcp.clientConfigs = {
      opencode = lib.mapAttrs (
        name: server:
        if server.type == "stdio" then
          {
            type = "local";
            command = server.command;
          }
          // (lib.optionalAttrs (server ? env) { env = server.env; })
          // {
            enabled = server.enabled or true;
          }
        else
          (removeAttrs server [
            "type"
            "description"
          ])
          // {
            type = "remote";
            enabled = server.enabled or true;
          }
      ) cfg.servers;

      zed-editor = lib.mapAttrs (
        name: server:
        if server.type == "stdio" then
          {
            command = builtins.head server.command;
            args = builtins.tail server.command;
          }
          // (lib.optionalAttrs (server ? env) { env = server.env; })
          // {
            enabled = server.enabled or true;
          }
        else
          (removeAttrs server [
            "type"
            "description"
          ])
          // {
            enabled = server.enabled or true;
          }
      ) cfg.servers;

      openclaw = lib.mapAttrs (
        name: server:
        let
          base = removeAttrs server [
            "type"
            "enabled"
            "description"
          ];
        in
        if server.type == "stdio" then
          base
          // {
            command = builtins.head server.command;
            args = builtins.tail server.command;
          }
        else if server.type == "streamable-http" then
          base
          // {
            transport = "streamable-http";
          }
        else
          server
      ) (lib.filterAttrs (n: s: s.enabled or true) cfg.servers);

      librechat = lib.mapAttrs (
        name: server:
        let
          base = {
            type = server.type;
          }
          // (lib.optionalAttrs (server ? description) { description = server.description; })
          // (lib.optionalAttrs (server ? headers) { headers = server.headers; });
        in
        if server.type == "stdio" then
          base
          // {
            command = builtins.head server.command;
            args = builtins.tail server.command;
          }
        else if server.type == "streamable-http" || server.type == "sse" then
          base
          // {
            url = server.url;
          }
        else
          { }
      ) (lib.filterAttrs (n: s: s.enabled or true) cfg.servers);
    };
  };
}
