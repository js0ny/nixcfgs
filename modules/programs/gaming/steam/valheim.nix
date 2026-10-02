{ pkgs, lib, ... }: {
  programs.steam.config.apps."892970" = {
    name = "Valheim";
    wrappers = [
      (lib.getExe pkgs.bashInteractive)
      "./start_game_bepinex.sh"
    ];
    args = [ "-console" ];
    env = {
      mesa_glthread = "true";
    };
  };
  xdg.dataFile = {
    "Steam/steamapps/common/Valheim" = {
      source = pkgs.js0ny.valheim-denkison-bepinexpack;
      recursive = true;
    };
    "Steam/steamapps/common/Valheim/BepInEx" = {
      source = pkgs.js0ny.valheim-plus;
      recursive = true;
    };
  };
}
