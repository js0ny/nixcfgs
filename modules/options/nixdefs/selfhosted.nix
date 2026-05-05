{ lib, ... }:
let
  inherit (lib) mkOption mkEnableOption;
in
{
  options.nixdefs.selfhosted = {
    searxng = {
      enable = mkEnableOption "Enable SearXNG integration";
      url = mkOption {
        type = lib.types.str;
        example = "https://searxng.example.com";
      };
      integrations = {
        defaultSearchEngine = mkOption {
          type = lib.types.bool;
          default = false;
        };
        alias = mkOption {
          type = lib.types.str;
          default = "sx";
          description = "The alias/prefix to call searxng in other software (like firefox search bar)";
        };
      };
    };
    open-webui = {
      enable = mkEnableOption "Enable Open WebUI integration";
      url = mkOption {
        type = lib.types.str;
        example = "https://open-webui.example.com";
      };
      integrations = {
        searchEngine = mkOption {
          type = lib.types.bool;
          default = false;
        };
        searchAlias = mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "@ai" ];
          description = "The alias/prefix to call open-webui in other software (like firefox search bar)";
        };
        searchParams = mkOption {
          type = lib.types.str;
          example = "?models=google/gemini-3-flash-preview&q=";
          default = "?q=";
        };
        firefox = mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable firefox sidebar AI integration";
        };
      };
    };
  };
}
