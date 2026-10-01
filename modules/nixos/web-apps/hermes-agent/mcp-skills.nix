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
  services.hermes-agent.mcpServers = {
    # tavily = {
    #   url = "${litellm}/tavily/mcp";
    #   headers = {
    #     Authorization = "Bearer \${LITELLM_API_KEY}";
    #   };
    # };
    # firecrawl = {
    #   url = "${litellm}/firecrawl/mcp";
    #   headers = {
    #     Authorization = "Bearer \${LITELLM_API_KEY}";
    #   };
    # };
    github = {
      url = "https://api.githubcopilot.com/mcp/";
      headers.Authorization = "Bearer \${GITHUB_TOKEN}";
    };
    grafana = {
      command = lib.getExe pkgs.js0ny.mcp-grafana;
      env = {
        GRAFANA_SERVICE_ACCOUNT_TOKEN_FILE = config.sops.secrets.grafana_mcp_api_key_hermes.path;
        GRAFANA_URL = config.nixdefs.endpoints.grafana.publicUrl;
      };
    };
  };

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
