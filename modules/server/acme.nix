{ config, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = config.js0ny.user.email;
  };

  nixdots.persist.system = {
    directories = [
      "/var/lib/acme"
    ];
  };
}
