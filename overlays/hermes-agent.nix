{ inputs }:

final: prev:
let
  patchedSource = final.applyPatches {
    name = "hermes-agent-source";
    src = inputs.hermes-agent.outPath;
    patches = [ ./patches/hermes-desktop-use-nixpkgs-electron-headers.patch ];
  };
in
{
  hermes-agent = prev.hermes-agent.overrideAttrs (
    finalAttrs: previousAttrs: {
      passthru = previousAttrs.passthru // {
        hermesDesktop = final.callPackage "${patchedSource}/nix/desktop.nix" {
          inherit (previousAttrs.passthru) hermesNpmLib;
          hermesAgent = finalAttrs.finalPackage;
        };
      };
    }
  );
}
