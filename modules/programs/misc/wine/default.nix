{
  flake.homeModules.wine =
    { pkgs, config, ... }:
    let
      prefix = "${config.xdg.dataHome}/wineprefixes/default";
      dwproton = pkgs.js0ny.dwproton-11;
    in
    {
      home.packages = with pkgs; [
        protontricks
        # Use Wayland-native wine for better performance and support
        wineWow64Packages.waylandFull
        winetricks
        (pkgs.bottles.override {
          removeWarningPopup = true;
        })
      ];
      nixdots.persist.nosnap.home = {
        directories = [
          ".local/share/wineprefixes"
          ".local/share/wine-apps"
          ".local/share/bottles"
        ];
      };
      home.sessionVariables = {
        WINEPREFIX = prefix;
      };

      xdg.dataFile."bottles/runners/dwproton-${dwproton.version}".source = dwproton;
      dconf.settings = {
        "com/usebottles/bottles" = {
          update-date = true;
          startup-view = "page_library";
          show-sandbox-warning = false;
          show-funding = false;
          steam-proton-support = true;
        };
      };

    };
}
