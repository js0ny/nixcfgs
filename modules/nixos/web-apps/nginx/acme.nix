{ config, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = config.js0ny.user.email;
  };

  js0ny.persist.stores.state.directories = [ "/var/lib/acme" ];
}
