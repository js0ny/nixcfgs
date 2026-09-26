{
  config,
  ...
}:
let
  cfg = config.services.forgejo;
  sshPort = cfg.settings.server.SSH_PORT;
  portStr = toString sshPort;
in
{
  # routers/web/auth/auth.go、modules/ssh/ssh.go
  # * "Failed authentication attempt for <user> from <HOST>"（web/API）
  # * "Failed authentication attempt from <HOST>"（SSH）
  environment.etc."fail2ban/filter.d/forgejo.conf".text = /* ini */ ''
    [Definition]
    failregex =  .*Failed authentication attempt( for .*)? from <HOST>
    ignoreregex =
  '';

  services.fail2ban.jails = {
    forgejo.settings = {
      backend = "auto";
      enabled = true;
      port = "80,443,${portStr}";
      protocol = "tcp";
      filter = "forgejo";
      maxretry = 10;
      bantime = 900;
      findtime = 3600;
      skip_if_nologs = true;
      logpath = "${cfg.stateDir}/log/gitea.log";
    };
  };
}
