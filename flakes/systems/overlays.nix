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
    # llm-agents does not put libtss2 in ChatGPT's buildInputs, so auto-formatelf
    # cannot resolve the TPM key module shipped in native/remote-control-device-key.node.
    (final: prev: {
      llm-agents = prev.llm-agents // {
        chatgpt = prev.llm-agents.chatgpt.override {
          chatgpt-unwrapped = prev.llm-agents.chatgpt.unwrapped.overrideAttrs (old: {
            buildInputs = old.buildInputs ++ [ final.tpm2-tss ];
          });
        };
      };
    })
    (final: prev: {
      llm-agents = prev.llm-agents // {
        hermes-agent = prev.llm-agents.hermes-agent.overridePythonAttrs (oldAttrs: {
          pythonRelaxDeps = (oldAttrs.pythonRelaxDeps or [ ]) ++ [
            "prompt-toolkit"
            "prompt_toolkit"
            "markdown"
          ];
        });
      };
    })
    (final: prev: {
      llm-agents = prev.llm-agents // {
        hermes-desktop = prev.llm-agents.hermes-desktop.override {
          hermes-agent = prev.llm-agents.hermes-agent.overridePythonAttrs (oldAttrs: {
            pythonRelaxDeps = (oldAttrs.pythonRelaxDeps or [ ]) ++ [
              "prompt-toolkit"
              "prompt_toolkit"
              "markdown"
            ];
          });

        };
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
