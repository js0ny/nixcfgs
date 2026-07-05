{
  flake.nixosModules.livekit =
    { ... }:
    {
      services.livekit = {
        enable = true;
      };
    };
}
