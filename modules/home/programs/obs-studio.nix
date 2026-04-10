{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.programs.obs-studio;
in
{
  config = lib.mkIf (cfg.enable && pkgs.stdenv.isLinux) (
    lib.mkMerge [
      {
        programs.obs-studio = {
          enable = true;
          plugins = cfg.plugins;
        };
      }

      (lib.mkIf (cfg.theme != "") {
        mergetools.OBSStudioConfig = {
          target = "${config.home.homeDirectory}/.config/obs-studio/user.ini";
          format = "ini";
          settings = {
            Appearance = {
              Theme = cfg.theme;
            };
          };
        };
      })
    ]
  );
}
