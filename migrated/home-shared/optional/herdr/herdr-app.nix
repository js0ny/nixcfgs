{
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  home.packages = lib.optionals osConfig.hardware.graphics.enable [
    pkgs.llm-agents.herdr-app
  ];
  xdg.configFile."herdr-app/keys.json".source = ./keys.json;
}
