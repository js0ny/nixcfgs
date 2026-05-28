{ config, ... }:
{
  services.fail2ban = {
    enable = true;
    # Sensible defaults for a server
    ignoreIP = config.secrets.plain.fail2ban.ignoreIP;
    maxretry = 5;
    bantime = "1h";
    # Incrementally increase ban time for repeat offenders
    bantime-increment = {
      enable = true;
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h";
    };
    jails = {
      # Basic SSH protection
      sshd.settings = {
        enabled = true;
        findtime = "10m";
        ignoreip = "100.64.0.0/10";
        banaction = "nftables-multiport";
        maxretry = 3;
        bantime = "24h";
      };
      recidive.settings = {
        enabled = true;
        banaction = "nftables-multiport";
        logpath = "/var/log/fail2ban.log";
        findtime = "24h";
        bantime = "168h";
      };
    };
  };
}
