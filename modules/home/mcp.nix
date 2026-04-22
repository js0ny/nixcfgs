{ lib, config, ... }:
let
  mcp = config.nixdefs.mcp;
in
lib.mkIf mcp.enable {
  programs.zed-editor.userSettings.context_servers = removeAttrs mcp.servers [ "type" ];
  programs.opencode.settings.mcp = mcp.servers;
}
