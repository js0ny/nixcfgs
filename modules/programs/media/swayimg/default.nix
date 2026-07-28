{
  flake.homeModules.swayimg =
    {
      pkgs,
      lib,
      config,
      inputs,
      ...
    }:
    lib.mkIf pkgs.stdenv.isLinux {
      programs.swayimg = {
        enable = true;
        initLua = builtins.readFile ./init.lua;
      };
      # https://github.com/artemsen/swayimg/blob/master/CONFIG.md
      xdg.configFile =
        let
          files = [
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
          "swayimg/.stylua.toml".source = "${inputs.self.outPath}/.stylua.toml";
        }
        // builtins.listToAttrs (
          map (e: {
            name = "swayimg/${e}";
            value.source = ./${e};
          }) files
        );
    };
  flake.homeModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.homeModules.swayimg ];
  };
}
