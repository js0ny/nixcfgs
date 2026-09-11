{
  flake.nixosModules.tailscale =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.js0ny.tailscale;
    in
    lib.mkIf cfg.enable {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = if cfg.exitNode then "server" else "none";
        authKeyFile = cfg.authKeyFile;
        extraUpFlags = [ "--reset" ];
        extraSetFlags = [ "--advertise-exit-node=${lib.boolToString cfg.exitNode}" ];
      };
      networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];

      js0ny.persist.stores.state.directories = [ "/var/lib/tailscale" ];
    };

  flake.darwinModules.tailscale =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.js0ny.tailscale;
    in
    lib.mkIf cfg.enable {
      services.tailscale.enable = true;
    };

}
