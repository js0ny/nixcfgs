{ pkgs, config, ... }:
let
  user = config.js0ny.user.name;
  ocbase = pkgs.llm-agents.opencode;
  ocpkg = pkgs.symlinkJoin {
    name = "opencode-with-bun";
    paths = [ ocbase ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/opencode" \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.bun ]} \
        --set BUN_TELEMETRY_DISABLED 1 \
        --set CI 1
    '';
  };
in
{
  services.hermes-agent.extraPackages = with pkgs; [
    # keep-sorted start
    agent-browser
    ffmpeg-headless
    gh
    jq
    nodejs_26
    ocpkg
    pyright
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

  users.users."${user}".extraGroups = [ config.services.hermes-agent.group ];
}
