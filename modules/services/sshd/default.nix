{
  flake.nixosModules.sshd = import ./nixos.nix;
  flake.darwinModules.sshd =
    { lib, config, ... }:
    let
      cfg = config.nixdots.services.sshd;
      portStr = config.nixdefs.endpoints.ssh.portStr;
    in
    lib.mkIf cfg.enable {
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
