{ config, lib, ... }:
let
  xdg-data = "${config.xdg.dataHome}";
  ollama = config.nixdefs.endpoints.ollama;
  port = ollama.port;
  addr = ollama.bindAddress;
  cfg = config.nixdots.services.ollama;
  # nvidia = config.nixdots.machine.nvidia.mode;
in
lib.mkIf (cfg.enable && !config.nixdots.linux.nixos) {
  services.ollama = {
    enable = true;
    # acceleration = if nvidia == "nvidia" then "cuda" else null;
    host = addr;
    port = port;
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
