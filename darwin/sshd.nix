{ lib, config, ... }:
let
  cfg = config.nixdots.services.sshd;
  portStr = config.nixdefs.endpoints.ssh.portStr;
in
lib.mkIf cfg {
  services.openssh = {
    enable = true;
    extraConfig = /* ssh_config */ ''
      Port ${portStr}
      PasswordAuthentication no
      PubkeyAuthentication yes
      PermitRootLogin no
    '';
  };
}
