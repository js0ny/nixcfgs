{ config, ... }:
let
  ep = config.nixdefs.endpoints;
in
{
  services.authelia.instances."main".settings = {
    identity_providers.oidc = {
      claims_policies = {
        grafana = {
          id_token = [
            "email"
            "name"
            "groups"
            "preferred_username"
          ];
        };
      };
      clients = [
        {
          # https://www.authelia.com/integration/openid-connect/clients/grafana
          client_id = "grafana";
          client_name = "Grafana";
          claims_policy = "grafana";
          public = false;
          authorization_policy = "two_factor";
          require_pkce = true;
          pkce_challenge_method = "S256";
          redirect_uris = [ "${ep.grafana.publicUrl}/login/generic_oauth" ];
          scopes = [
            "openid"
            "profile"
            "groups"
            "email"
          ];
          response_types = [ "code" ];
          grant_types = [ "authorization_code" ];
          access_token_signed_response_alg = "none";
          userinfo_signed_response_alg = "none";
          token_endpoint_auth_method = "client_secret_basic";
          client_secret = "$pbkdf2-sha512$310000$JMXLhxUBJvajF.Jt/dPmOQ$GTUFH6ce7DdEP2zMzKCGWysBKxEO8TXc7BpBhq6yIf8eKdQJc4bGJVZ.ZqBQB/d9QMnABpl.Pfw2pusCg8hj3A";
        }
      ];
    };

    access_control.rules = [
      {
        domain = ep.grafana.domain;
        subject = [ "group:admin" ];
        policy = "two_factor";
      }
    ];

  };
}
