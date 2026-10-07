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
    mcpServers = config.js0ny.mcp.clientSettings.hermes.mcp_servers;
    # https://hermes-agent.nousresearch.com/docs/user-guide/configuration#skill-settings
    settings.skills = {
      external_dirs = [ "/var/lib/hermes/agent-skills" ];
      write_approval = true; # stage every write for review `/skills pending`
    };
  };

  systemd.tmpfiles.rules = [
    "L+ /var/lib/hermes/.hermes/.no-bundled-skills - - - - ${pkgs.writeText ".no-bundled-skills" no-bundled-skills}"
  ];

}
