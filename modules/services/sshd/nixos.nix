{ lib, config, ... }:
let
  port = config.nixdefs.endpoints.ssh.port;
in
{
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
  assertions =
    let
      ports = config.services.openssh.ports;
    in
    [
      {
        assertion = ports == lib.unique ports;
        message = ''
          services.openssh.ports contains duplicate ports:
            ${lib.generators.toPretty { } ports}

          This usually means an OpenSSH module was imported more than once.
        '';
      }
    ];
}
