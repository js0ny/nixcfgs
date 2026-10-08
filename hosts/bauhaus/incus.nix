{ pkgs, ... }: {

  virtualisation.incus = {
    enable = true;
    package = pkgs.incus;
    ui.enable = true;
  };
  js0ny.user.groups = [ "incus-admin" ];
  networking.firewall.interfaces.incusbr0 = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [
      53
      67
    ];
  };
}
