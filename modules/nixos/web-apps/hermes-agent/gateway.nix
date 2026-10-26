{
  config,
  secrets,
  myLib,
  ...
}:
let
  sec = config.sops.placeholder;
  sopsFile = secrets + "/hermes.yaml";
in
{
  sops.templates."hermes-gateway.env".content = myLib.attrsToEnvFile {
    TELEGRAM_BOT_TOKEN = sec.hermes_telegram_bot_token;
    TELEGRAM_ALLOWED_USERS = sec.tg_main_chatid;
    TELEGRAM_HOME_CHANNEL = sec.tg_main_chatid;

    MATRIX_HOMESERVER = config.nixdefs.endpoints.matrix.publicUrl;
    MATRIX_USER_ID = "@hermes:js0ny.net";
    MATRIX_PASSWORD = sec.hermes_matrix_password;
    MATRIX_ALLOWED_USERS = "@js0ny:js0ny.net";
    #    MATRIX_ALLOWED_ROOMS = sec.hermes_matrix_allowed_rooms; # TODO: Matrix Control Pane
    MATRIX_HOME_ROOM = sec.hermes_matrix_home_room;
    MATRIX_E2EE_MODE = "optional";
  };

  sops.secrets = {
    hermes_telegram_bot_token = { inherit sopsFile; };
    hermes_matrix_password = { inherit sopsFile; };
    # hermes_matrix_allowed_rooms = { inherit sopsFile; };
    hermes_matrix_home_room = { inherit sopsFile; };
    # hermes_matrix_access_token = { inherit sopsFile; };
    # hermes_matrix_recovery_key = { inherit sopsFile; };
    tg_main_chatid = {
      sopsFile = secrets + "/telegram.yaml";
    };
  };

  services.hermes-agent = {
    environmentFiles = [ config.sops.templates."hermes-gateway.env".path ];
    environment.MATRIX_DM_AUTO_THREAD = "false";

    # https://github.com/NousResearch/hermes-agent/blob/main/cli-config.yaml.example
    settings = {
      group_sessions_per_user = true;

      # https://hermes-agent.nousresearch.com/docs/user-guide/messaging/matrix
      matrix = {
        require_mention = true;
        free_response_rooms = [ ];
        process_notices = false;
        session_scope = "auto";
        auto_thread = true;
        dm_mention_threads = false;
      };

      display.platforms.telegram = {
        tool_progress = "verbose";
        tool_progress_command = true;
        runtime_footer = {
          enabled = true;
          fields = [
            "model"
            "context_pct"
            "latency"
          ];
        };
        show_commentary = true;
        show_reasoning = true;
      };
    };
  };
}
