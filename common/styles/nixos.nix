{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdots.style;
  fontList =
    cfg.fonts.sansSerif
    ++ cfg.fonts.serif
    ++ cfg.fonts.editorMono
    ++ cfg.fonts.displayMono
    ++ cfg.fonts.emoji
    ++ cfg.fonts.extraFonts;
  fontPkgs = builtins.catAttrs "package" fontList;
in
lib.mkIf cfg.enable {
  environment.systemPackages = fontPkgs;

  fonts = {
    enableDefaultPackages = true;
    packages = fontPkgs;

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace =
          builtins.catAttrs "name" cfg.fonts.editorMono ++ builtins.catAttrs "name" cfg.fonts.displayMono;
        serif = builtins.catAttrs "name" cfg.fonts.serif;
        sansSerif = builtins.catAttrs "name" cfg.fonts.sansSerif;
      };
    };
    fontDir.enable = true;
  };

  system.fsPackages = [ pkgs.bindfs ];
  fileSystems =
    let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [
          "ro"
          "resolve-symlinks"
          "x-gvfs-hide"
        ];
      };
      aggregated = pkgs.buildEnv {
        name = "system-fonts-and-icons";
        paths = fontPkgs ++ [
          # Add cursor supports
          pkgs.kdePackages.breeze
        ]; # with pkgs; [
        #   libsForQt5.breeze-qt5

        #   noto-fonts
        #   noto-fonts-emoji
        #   noto-fonts-cjk-sans
        #   noto-fonts-cjk-serif
        # ];
        pathsToLink = [
          "/share/fonts"
          "/share/icons"
        ];
      };
    in
    lib.mkIf cfg.mountFHS {
      "/usr/share/icons" = mkRoSymBind "${aggregated}/share/icons";
      "/usr/share/fonts" = mkRoSymBind "${aggregated}/share/fonts";
      # Note: Binding to $HOME is not recommended since this binding process executes before mounting $HOME
    };
}
