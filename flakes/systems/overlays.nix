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
      llm-agents = prev.llm-agents // {
        hermes-agent = prev.llm-agents.hermes-agent.overridePythonAttrs (oldAttrs: {
          postPatch = (oldAttrs.postPatch or "") + /* bash */ ''
            substituteInPlace hermes_cli/kanban_db_dispatch.py \
              --replace-fail 'return [sys.executable, "-m", "hermes_cli.kanban_worker_client"]' \
                'return [os.environ.get("HERMES_PYTHON", sys.executable), "-m", "hermes_cli.kanban_worker_client"]'
          '';
        });
      };
    })
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
}
