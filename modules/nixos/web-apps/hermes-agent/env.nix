{
  config,
  secrets,
  myLib,
  ...
}:
let
  sec = config.sops.placeholder;
  ep = config.nixdefs.endpoints;
  sopsFile = secrets + "/hermes.yaml";
in
{
  sops.templates."hermes.env".content = myLib.attrsToEnvFile {
    LITELLM_API_KEY = sec.hermes_litellm_api_key;
    TAVILY_API_KEY = sec.tavily_api_key;

    GITHUB_TOKEN = sec.hermes_github_pat;
    GH_TOKEN = sec.hermes_github_pat;

    MINIFLUX_BASE_URL = ep.miniflux.publicUrl;
    MINIFLUX_API_TOKEN = sec.hermes_miniflux_api_token;

    HERMES_DASHBOARD_BASIC_AUTH_USERNAME = sec.hermes_dashboard_basic_auth_username;
    HERMES_DASHBOARD_BASIC_AUTH_PASSWORD_HASH = sec.hermes_dashboard_basic_auth_password_hash;
    HERMES_DASHBOARD_BASIC_AUTH_SECRET = sec.hermes_dashboard_basic_auth_secret;
    HERMES_DASHBOARD_SESSION_TOKEN = sec.hermes_session_token;
  };

  sops.secrets = {
    hermes_litellm_api_key = { inherit sopsFile; };
    hermes_github_pat = { inherit sopsFile; };
    hermes_miniflux_api_token = { inherit sopsFile; };
    hermes_session_token = { inherit sopsFile; };
    hermes_dashboard_basic_auth_secret = { inherit sopsFile; };
    hermes_dashboard_basic_auth_username = { inherit sopsFile; };
    hermes_dashboard_basic_auth_password_hash = { inherit sopsFile; };
    tavily_api_key = {
      sopsFile = secrets + "/mcp.yaml";
    };
  };

  services.hermes-agent = {
    environmentFiles = [
      config.sops.templates."hermes.env".path
    ];
  };
}
