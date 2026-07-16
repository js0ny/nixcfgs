{
  config,
  secrets,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  clientId = "matrix";
  matrixDomain = ep.matrix.domain;
  callbackUrl = "https://${matrixDomain}/_matrix/client/unstable/login/sso/callback/${clientId}";
in
{
  # [Human Intervention] Add the plaintext matrix_oidc_client_secret to matrix.yaml and update the secrets input.
  sops.secrets.matrix_oidc_client_secret = {
    sopsFile = secrets + /matrix.yaml;
    owner = config.services.matrix-tuwunel.user;
    group = config.services.matrix-tuwunel.group;
    restartUnits = [ "tuwunel.service" ];
  };

  # https://matrix-construct.github.io/tuwunel/authentication/providers/authelia.html
  services.matrix-tuwunel.settings.global.identity_provider = [
    {
      brand = "Authelia";
      name = "Authelia";
      client_id = clientId;
      client_secret_file = config.sops.secrets.matrix_oidc_client_secret.path;
      issuer_url = ep.authelia.publicUrl;
      callback_url = callbackUrl;
      default = true;
      scope = [
        "openid"
        "profile"
        "email"
        "groups"
      ];
      trusted = true;
      userid_claims = [ "preferred_username" ];
      unique_id_fallbacks = false;
      registration = true;
    }
  ];

  services.nginx.virtualHosts.${matrixDomain}.locations = {
    "/_tuwunel".proxyPass = "http://${ep.matrix.listenStr}";
    "= /.well-known/openid-configuration".proxyPass = "http://${ep.matrix.listenStr}";
  };
}
