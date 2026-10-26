{
  pkgs,
  config,
  inputs,
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
  imports = [
    "${inputs.secrets}/llm-contexts/nixos/hermes.nix"
  ];
  services.hermes-agent = {
    # The upstream mcpServers submodule does not expose the trust field.
    # https://hermes-agent.nousresearch.com/docs/reference/mcp-config-reference/
    settings.mcp_servers = config.js0ny.mcp.clientSettings.hermes.mcp_servers;
    # https://hermes-agent.nousresearch.com/docs/user-guide/configuration#skill-settings
    settings.skills = {
      external_dirs = [ "/var/lib/hermes/agent-skills" ];
      auto_load = [
        "workspace-management"
      ];
      disabled = [
        "obsidian"
        "airtable"
        "github-auth"
      ];
      write_approval = true; # stage every write for review `/skills pending`
    };
  };

  systemd.tmpfiles.rules = [
    "L+ /var/lib/hermes/.hermes/.no-bundled-skills - - - - ${pkgs.writeText ".no-bundled-skills" no-bundled-skills}"
  ];

}
