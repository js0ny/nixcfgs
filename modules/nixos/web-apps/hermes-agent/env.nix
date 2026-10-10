{
  config,
  secrets,
  myLib,
  ...
}:
let
  sec = config.sops.placeholder;
  ep = config.nixdefs.endpoints;
  inherit (config.services.hermes-agent) user group;
  sopsFile = secrets + "/hermes.yaml";
in
{
  # TODO:
  # MATRIX_ACCESS_TOKEN=${sec.hermes_matrix_access_token}
  # MATRIX_RECOVERY_KEY=${sec.hermes_matrix_recovery_key}
  sops.templates."hermes.env".content = myLib.attrsToEnvFile {
    LITELLM_API_KEY = sec.hermes_litellm_api_key;
    TAVILY_API_KEY = sec.tavily_api_key;
    TELEGRAM_BOT_TOKEN = sec.hermes_telegram_bot_token;
    TELEGRAM_ALLOWED_USERS = sec.tg_main_chatid;
    TELEGRAM_HOME_CHANNEL = sec.tg_main_chatid;
    MATRIX_HOMESERVER = ep.matrix.publicUrl;
    MATRIX_USER_ID = "@hermes:js0ny.net";
    MATRIX_ALLOWED_USERS = "@js0ny:js0ny.net";
    MATRIX_E2EE_MODE = "required";
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
    hermes_telegram_bot_token = { inherit sopsFile; };
    # hermes_matrix_access_token = { inherit sopsFile; };
    # hermes_matrix_recovery_key = { inherit sopsFile; };
    hermes_litellm_api_key = { inherit sopsFile; };
    hermes_github_pat = { inherit sopsFile; };
    hermes_miniflux_api_token = { inherit sopsFile; };
    hermes_session_token = { inherit sopsFile; };
    hermes_dashboard_basic_auth_secret = { inherit sopsFile; };
    hermes_dashboard_basic_auth_username = { inherit sopsFile; };
    hermes_dashboard_basic_auth_password_hash = { inherit sopsFile; };
    tg_main_chatid = {
      sopsFile = secrets + "/telegram.yaml";
    };
    tavily_api_key = {
      sopsFile = secrets + "/mcp.yaml";
    };
  };

  services.hermes-agent = {
    environmentFiles = [
      config.sops.templates."hermes.env".path
    ];
    environment = { };
  };
}
