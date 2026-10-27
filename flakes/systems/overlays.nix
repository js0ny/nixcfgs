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
      mcp-proxy = prev.mcp-proxy.overridePythonAttrs (oldAttrs: {
        dependencies = builtins.filter (dependency: dependency.pname != "mcp") oldAttrs.dependencies ++ [
          final.python314Packages.mcp_1
        ];
      });
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
      hermesSource = pkgs.applyPatches {
        name = "hermes-agent-patched-source";
        src = inputs.hermes-agent;
        patches = [
          # https://github.com/NousResearch/hermes-agent/pull/140767
          (pkgs.fetchpatch {
            name = "hermes-agent-nix-plugin-admission.patch";
            url = "https://github.com/NousResearch/hermes-agent/compare/e6cf2a9b1e8f98d40408b09a9a55993c8459b4b4...0d3a66101403af3f2e9d7124e9f387ed22a14570.diff";
            hash = "sha256-SnfoZvr92ODUlAZ4nYVedq1mtHoooXFfWBGD5it3DCY=";
            includes = [
              "pm/packages.py"
              "scripts/build/agent.py"
            ];
          })
        ];
        # The assembler needs uv.lock beside pyproject.toml, not a standalone store file.
        postPatch = /* bash */ ''
          substituteInPlace nix/hermes-agent.nix \
            --replace-fail 'project = "''${../pyproject.toml}";' \
              'project = "''${../.}/pyproject.toml";'
        '';
      };
      # Reuse the locked inputs and source identity while importing the patched build logic (IFD).
      hermesOutputs = (import (hermesSource + "/flake.nix")).outputs (
        inputs.hermes-agent.inputs
        // {
          self = inputs.hermes-agent // hermesOutputs // { outPath = toString hermesSource; };
        }
      );
    in
    {
      packages.hermes-agent =
        assert lib.assertMsg (
          metadata.rev == inputs.hermes-agent.rev
        ) "Hermes version metadata is stale; run `just update-hermes-version`.";
        hermesOutputs.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
          inherit (metadata) version distance;
        };
    };
}
