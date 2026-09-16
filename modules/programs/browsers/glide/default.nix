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
      dots = config.js0ny.host.flakeDir;
    in
    {
      imports = [
        inputs.glide-browser.homeModules.default
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

      programs.glide-browser = {
        enable = true;
        policies = {
          ExtensionSettings =
            with builtins;
            let
              extension = short: uuid: {
                name = uuid;
                value = {
                  install_url = "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
                  installation_mode = "force_installed";
                  private_browsing = true;
                };
              };
            in
            listToAttrs [
              (extension "ublock-origin" "uBlock0@raymondhill.net")
              (extension "multi-account-containers" "@testpilot-containers")
              (extension "side-view" "@webcompat@mozilla.org")
              (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
            ];
          "3rdparty".Extensions = {
            "uBlock0@raymondhill.net" = import ../firefox/ublock-origin.nix;
            "{3c078156-979c-498b-8990-85f7987dd929}" = import ../firefox/sidebery.nix;
          };
        };
      };
      js0ny.persist.stores.state.directories = [ ".config/glide" ];
    };
}
