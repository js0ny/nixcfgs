{
  description = "Sample devShell flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    {
      devShells =
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-darwin"
          ]
          (
            system:
            let
              pkgs = import nixpkgs {
                inherit system;
              };
              ciDeps = with pkgs; [
              ];
              devDeps = with pkgs; [
              ];
            in
            {
              default = pkgs.mkShell {
                buildInputs = ciDeps ++ devDeps;
                shellHook = ''

                '';
              };
              ci = pkgs.mkShell {
                buildInputs = ciDeps;
                shellHook = ''

                '';
              };
            }
          );
    };
}
