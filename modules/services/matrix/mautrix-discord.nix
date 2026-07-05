{
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
let
  ep = config.nixdefs.endpoints;
  epSelf = ep.mautrix-discord;
  domain = "js0ny.net";
  matrixPortStr = ep.matrix.portStr;
  port = epSelf.port;
  portStr = epSelf.portStr;
  user = "js0ny";
  botID = "discord";
  dname = "js0ny";
  sopsFile = secrets + /matrix.yaml;
  registerBot = pkgs.writeShellScript "register-mautrix-discord-bot" /* bash */ ''
    set -euo pipefail

    response="$(${lib.getExe pkgs.curl} -sS -w '\n%{http_code}' \
      -H "Authorization: Bearer $MAUTRIX_DISCORD_APPSERVICE_AS_TOKEN" \
      -H "Content-Type: application/json" \
      -d '{"type":"m.login.application_service","username":"${botID}bot","inhibit_login":true}' \
      -X POST 'http://localhost:${matrixPortStr}/_matrix/client/v3/register?kind=user')"

    status="''${response##*$'\n'}"
    body="''${response%$'\n'*}"

    case "$status" in
      2*) exit 0 ;;
    esac

    if [[ "$body" == *'M_USER_IN_USE'* ]]; then
      exit 0
    fi

    printf '%s\n' "$body" >&2
    exit 1
  '';
in
{
  sops.secrets = {
    mautrix_discord_as = { inherit sopsFile; };
    mautrix_discord_hs = { inherit sopsFile; };
  };
  sops.templates."mautrix-discord.env".content = /* bash */ ''
    MAUTRIX_DISCORD_APPSERVICE_AS_TOKEN=${config.sops.placeholder.mautrix_discord_as}
    MAUTRIX_DISCORD_APPSERVICE_HS_TOKEN=${config.sops.placeholder.mautrix_discord_hs}
  '';
  sops.templates."discord-registration.yaml" = {
    content = /* yaml */ ''
      id: ${botID}
      as_token: ${config.sops.placeholder.mautrix_discord_as}
      hs_token: ${config.sops.placeholder.mautrix_discord_hs}
      namespaces:
          users:
          - exclusive: true
            regex: '^@${botID}bot:${dname}\.net$'
          - exclusive: true
            regex: '^@${botID}_.*:${dname}\.net$'
          aliases:
          - exclusive: true
            regex: '^#${botID}_.*:${dname}\.net$'
      url: http://localhost:${portStr}
      sender_localpart: ${botID}bot
      rate_limited: false
      receive_ephemeral: true
      de.sorunome.msc2409.push_ephemeral: true
    '';
    path = "/var/lib/tuwunel/appservices/discord-registration.yaml";
    mode = "0600";
    owner = "tuwunel";
    group = "tuwunel";
  };
  services.mautrix-discord = {
    enable = true;
    environmentFile = config.sops.templates."mautrix-discord.env".path;
    # https://github.com/mautrix/discord/blob/main/example-config.yaml
    settings = {
      homeserver = {
        address = "http://localhost:${matrixPortStr}";
        domain = domain;
      };
      appservice = {
        address = "http://localhost:${portStr}";
        hostname = "0.0.0.0";
        port = port;
        database = {
          type = "sqlite3-fk-wal";
          uri = "file:${config.services.mautrix-discord.dataDir}/mautrix-discord.db?_txlock=immediate";
        };
        id = botID;
        as_token = "$MAUTRIX_DISCORD_APPSERVICE_AS_TOKEN";
        hs_token = "$MAUTRIX_DISCORD_APPSERVICE_HS_TOKEN";
        bot = {
          username = "${botID}bot";
          displayname = "Discord bridge bot";
          avatar = "mxc://maunium.net/nIdEykemnwdisvHbpxflpDlC";
        };
        ephemeral_events = true;
      };
      bridge = {
        permissions = {
          "${domain}" = "user";
          "@${user}:${domain}" = "admin";
          "@admin:${domain}" = "admin";
        };
        backfill = {
          forward_limits = {
            initial = {
              dm = 0;
              channel = 0;
              thread = 0;
            };
            missed = {
              dm = 0;
              channel = 0;
              thread = 0;
            };
          };
        };
      };
    };
  };
  systemd.services = {
    mautrix-discord = {
      wants = [ "tuwunel.service" ];
      after = [ "tuwunel.service" ];
      serviceConfig.ExecStartPre = registerBot;
    };
  };

  nixdots.persist.system = {
    directories = [
      {
        directory = config.services.mautrix-discord.dataDir;
        user = "mautrix-discord";
        mode = "0750";
      }
    ];
  };
  users.groups."mautrix-discord" = { };
  users.users.tuwunel.extraGroups = [ "mautrix-discord" ];
}
