{
  flake.nixosModules.server = { inputs, lib, ... }: {
    imports = with inputs.self.nixosModules; [
      core
      nginx
      tailscale
      podman
      sshd
    ];
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
