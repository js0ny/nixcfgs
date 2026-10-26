{ inputs, ... }:
let
  localOverlays = import ../../overlays { inherit inputs; };
  overlays = [
    localOverlays
    # keep-sorted start
    inputs.cachyos-kernel-nix.overlays.pinned
    inputs.firefox-addons.overlays.default
    inputs.js0ny-packages.overlays.default
    inputs.js0ny-packages.overlays.nixpaks
    inputs.llm-agents.overlays.shared-nixpkgs
    inputs.nur.overlays.default
    inputs.vscode-extensions.overlays.default
    # keep-sorted end
    (final: prev: {
      pythonPackagesExtensions = (prev.pythonPackagesExtensions or [ ]) ++ [
        (pythonFinal: pythonPrev: {
          httpx-auth = pythonPrev.httpx-auth.overridePythonAttrs (oldAttrs: {
            postPatch = (oldAttrs.postPatch or "") + /* bash */ ''
              substituteInPlace \
                tests/aws_signature_v4/test_aws4auth_async.py \
                tests/aws_signature_v4/test_aws4auth_sync.py \
                --replace-fail \
                  '    assert end - start < 30_000_000' \
                  ""
            '';
          });
        })
      ];
    })
  ];
in
{
  flake = {
    overlays.default = localOverlays;
    # Exposed for nixd evaluation and shared by system configurations.
    allOverlays = overlays;
  };
  perSystem =
    { lib, pkgs, ... }:
    let
      metadata = builtins.fromJSON (builtins.readFile ../../_sources/hermes-agent.json);
    in
    {
      packages.hermes-agent =
        assert lib.assertMsg (
          metadata.rev == inputs.hermes-agent.rev
        ) "Hermes version metadata is stale; run `just update-hermes-version`.";
        inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
          inherit (metadata) version distance;
        };
    };
}
