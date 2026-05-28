{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  user = config.nixdots.user.name;
  # system = pkgs.stdenv.system;
  # ocbase = inputs.llm-agents.packages.${system}.opencode;
  # # Wrap bun to perform plugin installation
  # ocpkg = pkgs.symlinkJoin {
  #   name = "opencode-with-bun";
  #   paths = [ ocpkg ];
  #   nativeBuildInputs = [ pkgs.makeWrapper ];
  #   postBuild = ''
  #     wrapProgram "$out/bin/opencode" \
  #       --prefix PATH : ${
  #         pkgs.lib.makeBinPath [
  #           pkgs.bun
  #           pkgs.git
  #           pkgs.cacert
  #         ]
  #       } \
  #       --set BUN_TELEMETRY_DISABLED 1 \
  #       --set CI 1
  #   '';
  # };
in
{
  users.groups = {
    agents = { };
    hermes = { };
  };
  users.users.hermes = {
    extraGroups = [ "hermes" ];
    packages = with pkgs; [
      # keep-sorted start
      ffmpeg-headless
      gh
      jq
      nodejs_24
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
