{
  flake.nixosModules.tailscale =
    {
      pkgs,
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
        authKeyFile = cfg.authKeyFile;
      };
      networking.firewall = {
        trustedInterfaces = [ "tailscale0" ];
      };
      nixdots.persist.system = {
        directories = [
          "/var/lib/tailscale"
        ];
      };
      boot.kernel.sysctl = (lib.mkIf cfg.exitNode) {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };
      systemd.services.tailscale-setup-exit-node = lib.mkIf cfg.exitNode {
        enable = true;
        description = "Advertise Tailscale exit node";

        wantedBy = [ "multi-user.target" ];
        requires = [ "tailscaled.service" ];
        after = [ "tailscaled.service" ];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${lib.getExe pkgs.tailscale} set --advertise-exit-node";
          RemainAfterExit = true;
        };
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
