{
  lib,
  config,
  ...
}: let
  absolutePathType = lib.types.addCheck lib.types.str (path: lib.hasPrefix "/" path);
  secretType = lib.types.submodule {
    freeformType = lib.types.attrsOf lib.types.anything;

    options.env = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "OPENROUTER_API_KEY";
      description = "Home-only shell environment variable populated from this secret file at runtime.";
    };
  };
in {
  options.nixdots.sops = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable shared sops integration for this module tree.";
    };

    yamlFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      example = lib.literalExpression "./secrets/secrets.yaml";
      description = "SOPS YAML file passed to `sops.defaultSopsFile`.";
    };

    sopsEditor = lib.mkOption {
      type = with lib.types; nullOr str;
      default =
        if config ? programs && config.programs ? neovim && config.programs.neovim.enable
        then "nvim --clean"
        else null;
      example = "nvim --clean";
      description = "Editor command exported as `SOPS_EDITOR`.";
    };

    keyFile = lib.mkOption {
      type = with lib.types; nullOr absolutePathType;
      default = null;
      example = "/home/pangu/.config/sops/age/keys.txt";
      description = "Absolute path to the age key file used by sops-nix.";
    };

    secrets = lib.mkOption {
      type = with lib.types; attrsOf secretType;
      default = {};
      example = lib.literalExpression ''
        {
          openrouter_api = {
            env = "OPENROUTER_API_KEY";
          };
          tavily_api = {
            env = "TAVILY_API_KEY";
          };
        }
      '';
      description = "Secret definitions forwarded to `sops.secrets`, with optional Home-specific `env` export support.";
    };
  };
}
