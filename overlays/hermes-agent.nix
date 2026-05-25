{ inputs }:

final: prev:
let
  hermesOverlay = inputs.hermes-agent.overlays.default final prev;
  hermesInputs = inputs.hermes-agent.inputs;
  patchedHermesAgent = final.applyPatches {
    name = "hermes-agent-patched-source";
    src = inputs.hermes-agent;
    patches = [
      (final.fetchpatch {
        url = "https://github.com/NousResearch/hermes-agent/pull/27056.patch";
        hash = "sha256-p5vVGVZrtAotpb6rI/kqopib3yUnlt8BYTkqt9sU39U=";
      })
    ];
  };
in
hermesOverlay
// {
  hermes-agent = final.callPackage "${patchedHermesAgent}/nix/hermes-agent.nix" {
    inherit (hermesInputs) uv2nix pyproject-nix pyproject-build-systems;
    npm-lockfile-fix =
      hermesInputs.npm-lockfile-fix.packages.${final.stdenv.hostPlatform.system}.default;
    rev = inputs.hermes-agent.rev or null;
  };
}
