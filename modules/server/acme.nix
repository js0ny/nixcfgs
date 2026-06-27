{ config, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = config.nixdots.user.email;
  };

  nixdots.persist.system = {
    directories = [
      "/var/lib/acme"
    ];
  };
}
