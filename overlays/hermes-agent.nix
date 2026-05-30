{ inputs }:

final: prev:
let
  hermesOverlay = inputs.hermes-agent.overlays.default final prev;
  hermesInputs = inputs.hermes-agent.inputs;
  patchedHermesAgent = final.applyPatches {
    name = "hermes-agent-patched-source";
    src = inputs.hermes-agent;
    patches = [ ./hermes-agent-patches/fix-include-messaging-deps-by-default.patch ];
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
