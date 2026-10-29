{ pkgs, ... }:
{
  virtualisation.incus = {
    enable = true;
    package = pkgs.incus;
    ui.enable = true;
    # https://linuxcontainers.org/incus/docs/main/howto/initialize/#non-interactive-configuration
    preseed = {
      config.https_address = "0.0.0.0:9191";
      networks = [
        {
          name = "incusbr0";
          type = "bridge";
          config = {
            "ipv4.address" = "10.0.100.1/24";
            "ipv4.nat" = "true";
            "ipv6.address" = "none";
          };
        }
      ];
      profiles = [
        {
          name = "default";
          devices = {
            eth0 = {
              name = "eth0";
              network = "incusbr0";
              type = "nic";
            };
            root = {
              path = "/";
              pool = "default";
              type = "disk";
            };
          };
        }
      ];
      storage_pools = [
        {
          name = "default";
          driver = "dir";
          config.source = "/var/lib/incus/storage-pools/default";
        }
      ];
    };
  };
  environment.systemPackages = [ pkgs.opentofu ];

  js0ny.user.groups = [ "incus-admin" ];
  networking.firewall.interfaces.incusbr0 = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [
      53
      67
    ];
  };
}
