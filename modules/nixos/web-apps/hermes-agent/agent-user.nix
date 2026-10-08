{
  pkgs,
  lib,
  config,
  ...
}:
let
  packages = with pkgs; [
    (python314.withPackages (ps: [
      # keep-sorted start
      ps.ddgs
      ps.pyyaml
      ps.requests
      # keep-sorted end
    ]))
    # keep-sorted start
    agent-browser
    chromium # deps of agent-browser
    ffmpeg-headless
    findutils
    gh
    jq
    nodejs_26
    poppler-utils
    ripgrep
    ripgrep-all
    shellcheck
    sqlite-interactive
    tea
    uv
    # keep-sorted end
  ];
  stateDir = "/var/lib/hermes";
  gitConfig = /* ini */ ''
    [user]
      email = "bot@js0ny.net"
      name = "js0ny LLM Agent"
  '';
in
{
  services.hermes-agent.extraPackages = packages;
  users.users.hermes = {
    packages = packages;
    shell = pkgs.bashInteractive;
  };
  environment.variables = {
    AGENT_BROWSER_EXECUTABLE_PATH = (lib.getExe pkgs.chromium);
  };

  js0ny.user.groups = [ config.services.hermes-agent.group ];

  systemd.tmpfiles.rules = [
    "L+ ${stateDir}/.gitconfig - - - - ${pkgs.writeText "gitconfig" gitConfig}"
  ];
}
