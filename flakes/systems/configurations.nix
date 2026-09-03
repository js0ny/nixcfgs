{
  config,
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs) lib;

  myLib = import ../../lib { inherit lib; };
  hosts = import ../../definitions/hosts.nix;
  overlays = config.flake.allOverlays;

  mkSpecialArgs = system: {
    inherit inputs overlays myLib;
    nixcfgs = inputs.self;
    bindeps = inputs.bindeps;
    secrets = inputs.secrets;
  };

  mkNixosSystem =
    hostname:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = mkSpecialArgs "x86_64-linux";
      modules = [
        # keep-sorted start
        inputs.catppuccin.nixosModules.catppuccin
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
        inputs.impermanence.nixosModules.impermanence
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.secrets.nixosModules.default
        inputs.stylix.nixosModules.default
        inputs.wsl-nixos.nixosModules.default
        # keep-sorted end
        ../../hosts/${hostname}
        { nixpkgs.overlays = overlays; }
      ];
    };

  mkDarwinSystem =
    hostname:
    inputs.nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = mkSpecialArgs "aarch64-darwin";
      modules = [
        ../../hosts/${hostname}
        { nixpkgs.overlays = overlays; }
        inputs.mac-app-util.darwinModules.default
        inputs.home-manager.darwinModules.default
        inputs.stylix.darwinModules.stylix
        inputs.secrets.darwinModules.default
      ];
    };
in
{
  flake = {
    nixosConfigurations = lib.genAttrs (lib.attrNames hosts.nixos) mkNixosSystem;
    darwinConfigurations = lib.genAttrs (lib.attrNames hosts.darwin) mkDarwinSystem;
  };
}
