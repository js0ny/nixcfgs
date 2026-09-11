{ lib, ... }:
{
  options.nixdots.services = {
    ollama = {
      enable = lib.mkEnableOption "Whether to enable ollama server for local large language models.";
      models = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "bge-m3" ];
        description = ''
          Download these models using ollama pull as soon as ollama.service has started.
        '';
      };
    };
  };

}
