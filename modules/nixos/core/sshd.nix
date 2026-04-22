{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.services.sshd;
  port = config.nixdefs.endpoints.ssh.port;
in
lib.mkIf cfg {
  services.openssh = {
    enable = true;
    ports = [ port ];
    settings = {
      UseDns = true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      # This is default to true, make sure override it when needed.
    };
  };
  networking.firewall.allowedTCPPorts = [ port ];
}
