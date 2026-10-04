{
  pkgs,
  lib,
  config,
  secrets,
  ...
}:
let
  # litellm = config.nixdefs.endpoints.litellm.publicUrl;
  no-bundled-skills = ''
    This profile opted out of bundled-skill seeding (`hermes skills opt-out`).
    Delete this file to re-enable sync on the next `hermes update`.
  '';
in
{
  services.hermes-agent.mcpServers = config.js0ny.mcp.clientSettings.hermes.mcp_servers;

  sops.secrets = {
    grafana_mcp_api_key_hermes = {
      sopsFile = secrets + "/mcp.yaml";
      key = "grafana_mcp_api_key";
      owner = "hermes";
      group = config.services.hermes-agent.group;
    };
  };

  systemd.tmpfiles.rules = [
    "L+ /var/lib/hermes/.hermes/.no-bundled-skills - - - - ${pkgs.writeText ".no-bundled-skills" no-bundled-skills}"
  ];

}
