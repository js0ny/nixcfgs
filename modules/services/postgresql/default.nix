{
  flake.nixosModules.postgresql =
    { ... }:
    {
      services.postgresql.enable = true;
    };
}
