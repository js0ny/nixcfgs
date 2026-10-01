{
  flake.nixosModules.gatus = { secrets, ... }: {
    imports = [
      "${secrets}/nixos/indep/gatus.nix"
    ];
    services.gatus.enable = true;

  };
}
