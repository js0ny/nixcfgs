{ inputs }:

final: prev:
let
  version = "1.4.9";
  bifrostInputs = inputs.bifrost.inputs;
  patchedBifrost = final.runCommand "source" { } /* bash */ ''
    cp -R --no-preserve=mode,ownership,timestamps ${inputs.bifrost}/. $out
    substituteInPlace $out/nix/packages/bifrost-ui.nix \
      --replace-fail "sha256-+tI2NUJtpHwvI9sAYMXO7r00Y3Pb1E62ms1ZSd3O0hM=" \
      "sha256-YniwFXRYyS8PpfabAAK0csyQLGrwUjONLTGXF7HINaI="
    substituteInPlace $out/nix/packages/bifrost-http.nix \
      --replace-fail "sha256-Ck1cwv/DYI9EXmp7U2ZSNXlU+Qok8BFn5bcN1Pv7Nmc=" \
      "sha256-tNQwOEgSgBTw5YRcAt9Y6Edjjbj2pMDITJV0tRL2E38="
  '';
in
{
  bifrost-ui = final.callPackage "${patchedBifrost}/nix/packages/bifrost-ui.nix" {
    src = patchedBifrost;
    inherit version;
  };

  bifrost-http = final.callPackage "${patchedBifrost}/nix/packages/bifrost-http.nix" {
    inputs = bifrostInputs;
    src = patchedBifrost;
    inherit version;
    bifrost-ui = final.bifrost-ui;
  };
}
