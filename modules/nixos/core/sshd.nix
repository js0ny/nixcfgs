{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.services.sshd;
in
lib.mkIf cfg {
  services.openssh = {
    enable = true;
    settings = {
      UseDns = true;
      PermitRootLogin = "no";
      # PasswordAuthentication = true;
      # This is default to true, make sure override it when needed.
    };
  };
}
