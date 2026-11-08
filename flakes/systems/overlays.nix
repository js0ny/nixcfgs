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
}
