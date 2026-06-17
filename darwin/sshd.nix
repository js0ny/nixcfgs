{ lib, config, ... }:
let
  cfg = config.nixdots.services.sshd;
  portStr = config.nixdefs.endpoints.ssh.portStr;
in
lib.mkIf cfg {
  services.openssh = {
    enable = true;
    extraConfig = /* sshdconfig */ ''
      Port ${portStr}
      PasswordAuthentication no
      PubkeyAuthentication yes
      PermitRootLogin no
    '';
  };
}
