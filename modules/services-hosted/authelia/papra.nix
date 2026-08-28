# https://www.authelia.com/integration/openid-connect/clients/papra/
{ config, ... }:
let
  ep = config.nixdefs.endpoints;
in
{
  services.authelia.instances."main".settings = {
    identity_providers.oidc.clients = [
      {
        client_id = "papra";
        client_name = "Papra";
        public = false;
        authorization_policy = "two_factor";
        require_pkce = true;
        pkce_challenge_method = "S256";
        redirect_uris = [ "${ep.papra.publicUrl}/api/auth/oauth2/callback/authelia" ];
        scopes = [
          "openid"
          "profile"
          "email"
        ];
        client_secret = "$pbkdf2-sha512$310000$ZYryBMuS8sdsjD8bz0ipDg$XHR0j6xYsTZv1zSqgAsJgVe7/ufRSaaOlGwkbijP70YWH3pM9VfpvQvXF66uhSxqZacXiJlOSFGOhIeprLPz8Q";
        response_types = [ "code" ];
        grant_types = [ "authorization_code" ];
        access_token_signed_response_alg = "none";
        userinfo_signed_response_alg = "none";
        token_endpoint_auth_method = "client_secret_post";
      }
    ];
  };
}
