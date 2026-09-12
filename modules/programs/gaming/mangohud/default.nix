{
  flake.homeModules.gaming =
    {
      pkgs,
      config,
      ...
    }:
    {
      programs.mangohud = {
        enable = true;
        package = pkgs.mangohud.override {
          nvidiaSupport = config.js0ny.hardware.gpu.driver == "nvidia";
        };
      };
    };
}
