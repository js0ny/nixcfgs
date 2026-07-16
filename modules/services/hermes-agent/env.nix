{ config, secrets, ... }:
let
  sec = config.sops.placeholder;
  ep = config.nixdefs.endpoints;
  obsidianDir = "/var/lib/lmwiki";
  sopsFile = secrets + /hermes.yaml;
in
{
  sops.templates."hermes.env".content = /* bash */ ''
    # LLM Integrations
    LITELLM_API_KEY=${sec.hermes_litellm_api_key}

    # Search
    TAVILY_API_KEY=${sec.tavily_api_key}


    ### Channels
    # Telegram
    TELEGRAM_BOT_TOKEN=${sec.hermes_telegram_bot_token}
    TELEGRAM_ALLOWED_USERS=${sec.tg_main_chatid}
    TELEGRAM_HOME_CHANNEL=${sec.tg_main_chatid}

    ### Integrations
    # GitHub
    GITHUB_TOKEN=${sec.hermes_github_pat}
    GH_TOKEN=${sec.hermes_github_pat}
    # Miniflux - RSS Reader
    MINIFLUX_BASE_URL=${ep.miniflux.publicUrl}
    MINIFLUX_API_TOKEN=${sec.hermes_miniflux_api_token}

    # Dashboard Basic Auth
    HERMES_DASHBOARD_BASIC_AUTH_USERNAME=${sec.hermes_dashboard_basic_auth_username}
    HERMES_DASHBOARD_BASIC_AUTH_PASSWORD_HASH=${sec.hermes_dashboard_basic_auth_password_hash}
    HERMES_DASHBOARD_BASIC_AUTH_SECRET=${sec.hermes_dashboard_basic_auth_secret}

    HERMES_DASHBOARD_SESSION_TOKEN=${sec.hermes_session_token}
  '';

  sops.secrets = {
    hermes_telegram_bot_token = { inherit sopsFile; };
    hermes_litellm_api_key = { inherit sopsFile; };
    hermes_github_pat = { inherit sopsFile; };
    hermes_miniflux_api_token = { inherit sopsFile; };
    hermes_session_token = { inherit sopsFile; };
    hermes_dashboard_basic_auth_secret = { inherit sopsFile; };
    hermes_dashboard_basic_auth_username = { inherit sopsFile; };
    hermes_dashboard_basic_auth_password_hash = { inherit sopsFile; };
    tg_main_chatid = {
      sopsFile = secrets + /telegram.yaml;
    };
    tavily_api_key = {
      sopsFile = secrets + /mcp.yaml;
    };
  };

  services.hermes-agent = {
    environmentFiles = [
      config.sops.templates."hermes.env".path
    ];
    environment = { };
  };
  sops.secrets.hermes_opencode_auth = {
    sopsFile = secrets + /hermes/opencode-auth.yaml;
    key = "data";
    owner = "hermes";
    group = "agents";
    path = "${config.users.users.hermes.home}/.local/share/opencode/auth.json";
  };
}
