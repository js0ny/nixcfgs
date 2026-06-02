{ lib, ... }:
let
  inherit (lib) mkOption mkDefault;
  endpointType = lib.types.submodule (
    { config, ... }:
    {
      options = {
        port = mkOption {
          type = lib.types.int;
          description = "Internal service port";
        };

        portStr = mkOption {
          type = lib.types.str;
          readOnly = true;
          default = toString config.port;
        };

        bindAddress = mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
        };

        domain = mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };

        listenStr = mkOption {
          type = lib.types.str;
          readOnly = true;
          default = "${config.bindAddress}:${toString config.port}";
        };

        publicUrl = mkOption {
          type = lib.types.nullOr lib.types.str;
          readOnly = true;
          default = if config.domain != null then "https://${config.domain}" else null;
        };
      };
    }
  );
in
{
  options.nixdefs.endpoints = mkOption {
    type = lib.types.attrsOf endpointType;
    default = { };
  };

  config.nixdefs.endpoints = {
    ssh.port = mkDefault 22;
    http.port = mkDefault 80;
    https.port = mkDefault 443;
    ollama = {
      port = mkDefault 11434;
    };
    librechat.port = mkDefault 3080;
    pdf2zh.port = mkDefault 7860;
    mongodb.port = mkDefault 27017;
    open-webui.port = mkDefault 8080;
    opencode.port = mkDefault 4096;
    prometheus-alertmanager.port = mkDefault 9093;
  };
}
