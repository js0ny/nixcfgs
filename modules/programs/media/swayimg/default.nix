{
  flake.homeModules.swayimg =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    lib.mkIf pkgs.stdenv.isLinux {
      programs.swayimg.enable = true;
      # https://github.com/artemsen/swayimg/blob/master/CONFIG.md
      xdg.configFile =
        let
          mkSymlink = config.lib.file.mkOutOfStoreSymlink;
          dots = config.nixdots.core.dots;
          files = [
            "init.lua"
            "utils.lua"

            "gallery.lua"
            "slideshow.lua"
            "viewer.lua"
          ];
        in
        {
          "swayimg/.luarc.json".text = builtins.toJSON {
            diagnostics.globals = [ "swayimg" ];
            workspace.library = [ "${config.programs.swayimg.package}/share/swayimg" ];
          };
        }
        // builtins.listToAttrs (
          map (e: {
            name = "swayimg/${e}";
            value.source = mkSymlink "${dots}/modules/programs/media/swayimg/${e}";
          }) files
        );
    };
  flake.homeModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.homeModules.swayimg ];
  };
}
