{
  pkgs,
  lib,
  config,
  inputs,
  secrets,
  ...
}:
let
  user = config.nixdots.user.name;
  system = pkgs.stdenv.system;
  ocbase = inputs.llm-agents.packages.${system}.opencode;
  # Wrap bun to perform plugin installation
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
  users.groups = {
    agents = { };
    hermes = { };
  };
  users.users.hermes = {
    group = "agents";
    homeMode = "750";
    extraGroups = [ "hermes" ];
    packages = with pkgs; [
      # keep-sorted start
      ffmpeg-headless
      gh
      jq
      nodejs_26
      ocpkg
      python315
      ripgrep
      ripgrep-all
      sqlite-interactive
      tea
      uv
      # keep-sorted end
    ];
  };
  users.users."${user}".extraGroups = [
    "agents"
    "hermes"
  ];
}
