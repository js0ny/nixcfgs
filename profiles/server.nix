{ config, ... }:
{
  flake.nixosModules.server = { lib, ... }: {
    imports = with config.flake.nixosModules; [
      core
      nginx
      tailscale
      podman
      sshd
    ];
    # Server config
    networking = {
      nameservers = [
        "1.1.1.1"
        "8.8.8.8"
        "2606:4700:4700::1111"
        "2001:4860:4860::8888"
      ];
    };
    js0ny.persist.stores.state.directories = [ "/var/lib/systemd/network" ];
    # TODO: Split to `guest`
    services.spice-vdagentd.enable = lib.mkDefault true;
    services.qemuGuest.enable = lib.mkDefault true;

    systemd = {
      sleep.settings.Sleep = {
        AllowSuspend = "no";
        AllowHibernation = "no";
      };
    };
    security.sudo-rs.wheelNeedsPassword = false;
  };
}
