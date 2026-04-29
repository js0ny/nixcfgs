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
  };
}
