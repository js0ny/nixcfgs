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
          nvidiaSupport = config.nixdots.linux.gpu == "nvidia";
        };
      };
    };
}
