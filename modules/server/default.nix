{
  flake.nixosModules.nginx = import ./nginx.nix;

  flake.nixosModules.server = _: {
    # Server config
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

  flake.homeModules.server = { inputs, lib, ... }: {
    programs.plasma.enable = lib.mkForce false;
    dconf.enable = false;
    imports = [
      inputs.self.homeModules.linux
    ];
  };
}
