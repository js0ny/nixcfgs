{
  flake.nixosModules.sshd =
    { lib, config, ... }:
    let
      cfg = config.nixdots.services.sshd;
      port = config.nixdefs.endpoints.ssh.port;
    in
    lib.mkIf cfg.enable {
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
    };
  flake.darwinModules.sshd =
    { lib, config, ... }:
    let
      cfg = config.nixdots.services.sshd;
      portStr = config.nixdefs.endpoints.ssh.portStr;
    in
    lib.mkIf cfg {
      services.openssh = {
        enable = true;
        extraConfig = /* ssh_config */ ''
          PasswordAuthentication no
          PubkeyAuthentication yes
          PermitRootLogin no
          Port ${portStr}
        '';
      };
    };
}
