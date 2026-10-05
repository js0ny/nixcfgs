{
  flake.homeModules = {
    mediatools =
      { inputs, ... }:
      {
        imports = [
          ./packages.nix
          inputs.self.homeModules.beets
          ./gallery-dl.nix
        ];
      };
    desktop = { pkgs, inputs, ... }: {
      imports = [
        inputs.self.homeModules.mediatools
        ./sonora.nix
        ./mpv.nix
        ./ratune.nix
      ];
      home.packages = [
        inputs.rox.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
  };
}
