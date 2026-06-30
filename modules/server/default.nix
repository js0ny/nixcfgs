{
  flake.nixosModules.nginx = import ./nginx.nix;

  flake.nixosModules.server = { inputs, ... }: {
    imports = [
      inputs.self.nixosModules.nginx
      inputs.self.nixosModules.core
      inputs.self.nixosModules.sshd
    ];
    # TODO: Split to `guest`
    services.spice-vdagentd.enable = true;
    services.qemuGuest.enable = true;
    # Server config
    virtualisation.podman.enable = true;
    virtualisation.oci-containers.backend = "podman";
    environment.shellAliases = {
      sc = "systemctl";
      scc = "systemctl cat";
      scs = "systemctl status";
      jc = "journalctl";
      jcx = "journalctl -xeu";
    };
    networking = {
      nameservers = [
        "1.1.1.1"
        "8.8.8.8"
        "2606:4700:4700::1111"
        "2001:4860:4860::8888"
      ];
    };
    nixdots.persist.system = {
      directories = [
        "/var/lib/systemd/network"
        "/var/lib/systemd/rfkill"
      ];
    };
  };
}
