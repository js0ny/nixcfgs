{ lib, config, ... }:
let
  cfg = config.nixdefs.acp;
  acpServerType = lib.types.submodule {
    options = {
      enable = lib.mkEnableOption "this ACP server";

      command = lib.mkOption {
        type = lib.types.str;
        description = "The executable command for the ACP server.";
      };

      args = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Arguments to pass to the command.";
      };
    };
  };
in
{
  options.nixdefs = {
    acp = {
      enable = lib.mkEnableOption "Global MCP (Model Context Protocol) configuration";
      servers = lib.mkOption {
        type = lib.types.attrsOf acpServerType;
        default = { };
      };
    };
  };
}
