{
  config,
  inputs,
  lib,
  ...
}:
let
  ep = config.nixdefs.endpoints.marimohub;
  tailnetInterface = config.services.tailscale.interfaceName;
in
{
  imports = [ inputs.self.nixosModules.marimohub ];

  nixdefs.endpoints.marimohub.bindAddress = config.js0ny.tailscale.ipv4;

  virtualisation.oci-containers.containers.marimohub.environment = {
    # Tailnet-only evaluation: every permitted peer shares this identity.
    MARIMOHUB_AUTH_BACKEND = lib.mkDefault "dev";
    MARIMOHUB_AUTH_DEV_USER_ID = "js0ny";
    MARIMOHUB_AUTH_DEV_EMAIL = "js0ny@localhost";
    MARIMOHUB_AUTH_DEV_NAME = "js0ny";
    MARIMOHUB_SUPER_ADMINS = "js0ny";
  };

  # Binding a Tailnet IP alone does not reject packets routed through other interfaces.
  networking.nftables.tables.marimohub-tailnet = {
    family = "inet";
    content = /* nft */ ''
      chain input {
        type filter hook input priority -10; policy accept;
        ip daddr ${ep.bindAddress} tcp dport ${ep.portStr} iifname != { "${tailnetInterface}", "lo" } drop
      }
    '';
  };

  systemd.services.podman-marimohub = {
    requires = [
      "nftables.service"
      "tailscaled.service"
    ];
    after = [
      "nftables.service"
      "tailscaled.service"
    ];
  };
}
