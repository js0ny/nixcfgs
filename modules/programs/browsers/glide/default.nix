{
  flake.homeModules.glide =
    {
      pkgs,
      inputs,
      config,
      ...
    }:
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
      dots = config.nixdots.core.dots;
    in
    {
      home.packages = [
        inputs.glide-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      xdg.configFile =
        let
          files = [
            "eslint.config.js"
            "tsconfig.json"
            "glide.ts"
            # keep-sorted start
            "excmd-alias.glide.ts"
            "picker.glide.ts"
            "prefs.glide.ts"
            "search-engines.glide.ts"
            "userjs.glide.ts"
            # keep-sorted end
          ];
        in
        builtins.listToAttrs (
          map (e: {
            name = "glide/${e}";
            value.source = mkSymlink "${dots}/modules/programs/browsers/glide/${e}";
          }) files
        );
      nixdots.persist.home.directories = [ ".config/glide" ];
    };
}
