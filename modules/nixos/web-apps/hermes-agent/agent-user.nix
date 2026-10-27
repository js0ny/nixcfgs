{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  nixpkgs-pr-tracker = pkgs.writers.writeNuBin "nixpkgs-pr-tracker" { } (
    builtins.readFile "${inputs.self.outPath}/.bin/nixpkgs-pr-tracker.nu"
  );
  packages = with pkgs; [
    (python314.withPackages (ps: [
      # keep-sorted start
      ps.ddgs
      ps.pymupdf
      ps.pymupdf4llm
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
    git # required by installing plugins
    jq
    js0ny.edstem-cli
    localPkgs.pdf2zh-next
    nixpkgs-pr-tracker
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
  inherit (config.services.hermes-agent)
    user
    stateDir
    group
    workingDirectory
    ;
  hermesHome = "${stateDir}/.hermes";
  gitConfig = /* ini */ ''
    [user]
      email = "bot@js0ny.net"
      name = "js0ny LLM Agent"
  '';
in
{
  services.hermes-agent.extraPackages = packages;
  environment.variables = {
    AGENT_BROWSER_EXECUTABLE_PATH = (lib.getExe pkgs.chromium);
  };

  js0ny.user.groups = [ config.services.hermes-agent.group ];

  systemd.tmpfiles.rules = [
    "L+ ${stateDir}/.gitconfig - - - - ${pkgs.writeText "gitconfig" gitConfig}"
  ]
  ++ map (directory: "A+ ${directory} - - - - g:${group}:rwX,d:g:${group}:rwX") (
    lib.unique [
      stateDir
      workingDirectory
    ]
  )
  ++ [
    "A+ ${hermesHome} - - - - g:${group}:rX,d:g:${group}:rX"
    "z ${hermesHome} 0750 ${user} ${group} - -"
  ];
}
