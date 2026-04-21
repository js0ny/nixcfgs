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
    };
  };
}
