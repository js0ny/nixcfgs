{ config, ... }:
let
  ep = config.nixdefs.endpoints;
in
{
  services.authelia.instances."main".settings = {
    identity_providers.oidc.clients = [
      {
        client_id = "jellyfin";
        client_name = "Jellyfin";
        public = false;
        authorization_policy = "two_factor";
        require_pkce = true;
        pkce_challenge_method = "S256";
        redirect_uris = [ "${ep.jellyfin.publicUrl}/sso/OID/redirect/authelia" ];
        scopes = [
          "openid"
          "profile"
          "groups"
        ];
        client_secret = "$pbkdf2-sha512$310000$/dZZ/ldjypHqtUYq//vUSg$iuBcrzd9ckMi4TU/kSwpuOv7Jwobj1afYNFu25H4U0cNazpM1uhezI6yF3OD/CSSaKxet1ShM/21QfhgNjzg4g";
        response_types = [ "code" ];
        grant_types = [ "authorization_code" ];
        access_token_signed_response_alg = "none";
        userinfo_signed_response_alg = "none";
        token_endpoint_auth_method = "client_secret_post";
      }
    ];
  };
}
