{
  flake.nixosModules.tailscale =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.nixdots.services.tailscale;
    in
    lib.mkIf cfg.enable {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = if cfg.exitNode then "server" else "none";
        authKeyFile = cfg.authKeyFile;
        extraUpFlags = [ "--reset" ];
        extraSetFlags = lib.optionals (cfg.exitNode) [ "--advertise-exit-node" ];
      };
      networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];

      js0ny.persist.stores.state.directories = [ "/var/lib/tailscale" ];
      boot.kernel.sysctl = (lib.mkIf cfg.exitNode) {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };
    };

  flake.darwinModules.tailscale =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.nixdots.services.tailscale;
    in
    lib.mkIf cfg.enable {
      services.tailscale.enable = true;
    };

}
