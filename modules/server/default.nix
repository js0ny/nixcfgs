{
  flake.nixosModules.acme = import ./acme.nix;
  flake.nixosModules.nginx = import ./nginx.nix;
  flake.nixosModules.server-core = import ./core.nix;
  flake.nixosModules.server-networking = import ./networking.nix;

  flake.nixosModules.server = _: {
    imports = [
      ./core.nix
      ./networking.nix
      ./nginx.nix
    ];
  };
}
