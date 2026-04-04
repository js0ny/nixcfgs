{
  lib,
  config,
  ...
}: let
  cfg = config.nixdots.services.tailscale;
in {
  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = cfg.openFirewall;
      authKeyFile = cfg.authKeyFile;
    };
    networking.firewall = {
      trustedInterfaces = lib.mkIf cfg.trustInterface ["tailscale0"];
    };
    nixdots.persist.system = {
      directories = [
        "/var/lib/tailscale"
      ];
    };
  };
}
