{ lib, config, ... }:
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
    };
  };
  config = lib.mkIf cfg.enable {
    nixdefs.mcp.servers = {
      deepwiki = {
        type = "remote";
        url = "https://mcp.deepwiki.com/mcp";
        enabled = true;
      };
      context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
        headers = {
          "CONTEXT7_API_KEY" = "{env:CONTEXT7_API_KEY}";
        };
        enabled = true;
      };
      gh_grep = {
        type = "remote";
        url = "https://mcp.grep.app";
        enabled = true;
      };
      mcp-nixos = {
        type = "local";
        command = [
          "mcp-nixos"
        ];
        enabled = true;
      };
    };
  };
}
