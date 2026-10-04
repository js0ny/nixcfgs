{
  pkgs,
  lib,
  config,
  secrets,
  ...
}:
let
  pibase = pkgs.llm-agents.omp;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  ompTelegram = pkgs.js0ny.omp-telegram;
  pi = pkgs.symlinkJoin {
    name = "omp-env";
    paths = [ pibase ];
    meta = pibase.meta // {
      mainProgram = "omp";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    /*nixfmt:disable*/
    postBuild = ''
      wrapProgram "$out/bin/omp" \
        --prefix PATH : ${ lib.makeBinPath [ pkgs.python3 pkgs.nodejs ] } \
        --set PI_CODING_AGENT_SESSION_DIR "${config.xdg.dataHome}/omp/agent/session" \
        --set PI_CODING_AGENT_DIR "${config.xdg.configHome}/omp/agent"
    '';
    /*nixfmt:enable*/
  };
in
{
  home.packages = [ pi ] ++ lib.optionals isLinux [ ompTelegram ];

  js0ny.persist.stores.state.directories = [
    ".config/omp"
    ".local/share/omp-telegram"
  ];

  sops.secrets = lib.optionalAttrs isLinux {
    omp_telegram_bot_token.sopsFile = secrets + "/telegram.yaml";
    tg_main_chatid.sopsFile = secrets + "/telegram.yaml";
  };

  sops.templates = lib.optionalAttrs isLinux {
    "omp-telegram.toml" = {
      content = /* toml */ ''
        [telegram]
        token = "${config.sops.placeholder.omp_telegram_bot_token}"
        allowed_users = ["${config.sops.placeholder.tg_main_chatid}"]
        allowed_chats = ["${config.sops.placeholder.tg_main_chatid}"]
        progress_mode = "summary"

        [omp]
        binary = "${lib.getExe pi}"
        args = ""

        [omp.environment]
        mode = "denylist"
        deny = [ "OMP_TELEGRAM_BOT_TOKEN" ]

        [storage]
        data_dir = "${config.xdg.dataHome}/omp-telegram"
        workspace_root = "${config.home.homeDirectory}/Atelier/omp-workspaces"
        database_retention_days = 90

        [worker]
        max_workers = 8
        queue_capacity = 16
        idle_timeout = "30m"

        [logging]
        level = "info"
        format = "text"
      '';
      path = "${config.xdg.configHome}/omp-telegram/config.toml";
    };
  };

  systemd.user.services = lib.optionalAttrs isLinux {
    omp-telegram = {
      Unit.Description = "Telegram bridge for Oh My Pi";
      Service = {
        ExecStart = lib.escapeShellArgs [
          (lib.getExe ompTelegram)
          "--config"
          config.sops.templates."omp-telegram.toml".path
        ];
        Restart = "on-failure";
        RestartSec = 5;
        WorkingDirectory = config.home.homeDirectory;
      };
    };
  };
}
