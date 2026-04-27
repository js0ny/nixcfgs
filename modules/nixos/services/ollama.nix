{ config, lib, ... }:
let
  ollama = config.nixdefs.endpoints.ollama;
  port = ollama.port;
  addr = ollama.bindAddress;
  cfg = config.nixdots.services.ollama;
  # nvidia = config.nixdots.machine.nvidia.mode;
in
lib.mkIf (cfg.enable) {
  services.ollama = {
    enable = true;
    host = addr;
    port = port;
    syncModels = lib.mkDefault true;
    loadModels = cfg.models;
  };
  nixdots.persist.system = {
    directories = [
      "/var/lib/private/ollama"
    ];
  };
}
