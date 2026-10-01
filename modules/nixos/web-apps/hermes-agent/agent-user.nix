{
  pkgs,
  lib,
  config,
  ...
}:
let
  user = config.js0ny.user.name;
  packages = with pkgs; [
    # keep-sorted start
    agent-browser
    chromium # deps of agent-browser
    ffmpeg-headless
    findutils
    gh
    jq
    nodejs_26
    python314
    python314Packages.ddgs
    python314Packages.mdformat
    python314Packages.mdformat-gfm
    ripgrep
    ripgrep-all
    shellcheck
    sqlite-interactive
    tea
    uv
    # keep-sorted end
  ];
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

  users.users."${user}".extraGroups = [ config.services.hermes-agent.group ];
}
