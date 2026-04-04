{config, ...}: let
  xdg-data = "${config.xdg.dataHome}";
in {
  services.ollama = {
    enable = true;
  };
  nixdots.persist.home = {
    directories = [
      ".ollama"
      ".local/share/ollama"
    ];
  };
  home.sessionVariables = {
    OLLAMA_MODELS = "${xdg-data}/ollama/models"; # Only for models aka ~/.ollama/models
  };
}
