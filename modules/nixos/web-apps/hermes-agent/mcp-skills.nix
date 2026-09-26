{ pkgs, config, ... }:
let
  litellm = config.nixdefs.endpoints.litellm.publicUrl;
  no-bundled-skills = ''
    This profile opted out of bundled-skill seeding (`hermes skills opt-out`).
    Delete this file to re-enable sync on the next `hermes update`.
  '';
in
{
  services.hermes-agent.mcpServers = {
    tavily = {
      url = "${litellm}/tavily/mcp";
      headers = {
        Authorization = "Bearer \${LITELLM_API_KEY}";
      };
    };
    firecrawl = {
      url = "${litellm}/firecrawl/mcp";
      headers = {
        Authorization = "Bearer \${LITELLM_API_KEY}";
      };
    };
    github = {
      url = "https://api.githubcopilot.com/mcp/";
      headers.Authorization = "Bearer \${GITHUB_TOKEN}";
    };
  };

  systemd.tmpfiles.rules = [
    "L+ /var/lib/hermes/.hermes/.no-bundled-skills - - - - ${pkgs.writeText ".no-bundled-skills" no-bundled-skills}"
  ];

}
