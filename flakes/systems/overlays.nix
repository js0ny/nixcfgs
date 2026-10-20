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
    # (final: prev: {
    #   llm-agents = prev.llm-agents // {
    #     hermes-desktop = prev.llm-agents.hermes-desktop.overrideAttrs (oldAttrs: {
    #       nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ final.imagemagick ];
    #       postInstall = (oldAttrs.postInstall or "") + /* bash */ ''
    #         # Vicinae does not reliably resolve the upstream 1024x1024-only icon.
    #         sourceIcon="$out/share/icons/hicolor/1024x1024/apps/hermes-desktop.png"
    #         for size in 256 512; do
    #           install -d "$out/share/icons/hicolor/''${size}x''${size}/apps"
    #           magick "$sourceIcon" -resize "''${size}x''${size}" \
    #             "$out/share/icons/hicolor/''${size}x''${size}/apps/hermes-desktop.png"
    #         done
    #       '';
    #     });
    #   };
    # })
  ];
in
{
  flake = {
    overlays.default = localOverlays;
    # Exposed for nixd evaluation and shared by system configurations.
    allOverlays = overlays;
  };
}
