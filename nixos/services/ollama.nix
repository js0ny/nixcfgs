{ config, lib, ... }:
let
  epSelf = config.nixdefs.endpoints.ollama;
  port = epSelf.port;
  bind = epSelf.bindAddress;
  cfg = config.nixdots.services.ollama;
  # nvidia = config.nixdots.machine.nvidia.mode;
in
lib.mkIf (cfg.enable) {
  services.ollama = {
    enable = true;
    host = bind;
    port = port;
    syncModels = lib.mkDefault true;
    loadModels = cfg.models;
  };
}
