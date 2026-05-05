{ lib, ... }:
let
  endpointType = lib.types.submodule (
    { config, ... }:
    {
      options = {
        port = lib.mkOption {
          type = lib.types.int;
          description = "Internal service port";
        };

        bindAddress = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
        };

        domain = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };

        listenStr = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = "${config.bindAddress}:${toString config.port}";
        };

        publicUrl = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          readOnly = true;
          default = if config.domain != null then "https://${config.domain}" else null;
        };
      };
    }
  );
in
{
  options.nixdefs.endpoints = lib.mkOption {
    type = lib.types.attrsOf endpointType;
    default = { };
  };

  config.nixdefs.endpoints = {
    ssh.port = lib.mkDefault 22;
    http.port = lib.mkDefault 80;
    https.port = lib.mkDefault 443;
    ollama = {
      port = lib.mkDefault 11434;
    };
    librechat.port = lib.mkDefault 3080;
    pdf2zh.port = lib.mkDefault 7860;
    mongodb.port = lib.mkDefault 27017;
    open-webui.port = lib.mkDefault 8080;
  };
}
