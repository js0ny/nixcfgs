{
  flake.nixosModules.uxplay =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      port = 35000;
      portRange = {
        from = port;
        to = port + 2;
      };
    in
    {
      environment.systemPackages = [ pkgs.uxplay ];

      services.avahi = {
        enable = true;
        # Tether enables Avahi's global firewall rule; keep mDNS interface-scoped.
        openFirewall = lib.mkForce false;
        publish = {
          enable = true;
          userServices = true;
        };
      };

      networking.firewall.interfaces = lib.genAttrs config.js0ny.hardware.localInterfaces (_: {
        allowedTCPPortRanges = [ portRange ];
        allowedUDPPorts = [ 5353 ];
        allowedUDPPortRanges = [ portRange ];
      });

      home-manager.sharedModules = [
        {
          xdg.configFile."uxplayrc".text = /* conf */ ''
            p ${toString port}
          '';
        }
      ];
    };
}
