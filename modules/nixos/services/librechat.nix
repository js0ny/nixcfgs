{ lib, config, ... }:
let
  ep = config.nixdefs.endpoints.librechat;
in
{
  services.librechat = {
    # https://www.librechat.ai/docs/configuration/dotenv
    env = {
      PORT = ep.port;
      HOST = ep.bindAddress;
      ALLOW_REGISTRATION = lib.mkDefault true;
      MONGO_URI = lib.mkDefault "mongodb://127.0.0.1:${toString config.nixdefs.endpoints.mongodb.port}/LibreChat";
      ENDPOINTS = lib.mkDefault "OpenRouter,openAI,anthropic";
      ANTHROPIC_API_KEY = lib.mkDefault "user_provided";
      OPENAI_API_KEY = lib.mkDefault "user_provided";
      GOOGLE_KEY = lib.mkDefault "user_provided";
      ALLOW_SHARED_LINKS = lib.mkDefault "true";
      # Allows unauthenticated access to shared links. Defaults to false (auth required) if not set.
      ALLOW_SHARED_LINKS_PUBLIC = lib.mkDefault "false";
    };
    # like env = {} but passing file path
    # required:
    # CREDS_KEY
    # CREDS_IV
    # JWT_SECRET
    # JWT_REFRESH_SECRET
    credentials = { };
    # https://www.librechat.ai/docs/configuration/librechat_yaml
    settings = {
      version = lib.mkDefault "1.3.9";
      cache = true;

      interface = {
        privacyPolicy = lib.mkDefault {
          externalUrl = "https://librechat.ai/privacy-policy";
          openNewTab = true;
        };
        termsOfService = lib.mkDefault {
          externalUrl = "https://librechat.ai/tos";
          openNewTab = true;
        };
      };
    };
    # enableLocalDB = true;
  };
}
