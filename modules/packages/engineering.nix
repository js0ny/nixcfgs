{
  flake.homeModules.engineering =
    { pkgs, lib, ... }:
    lib.mkMerge [
      (lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) {
        home.packages = with pkgs; [
          # freecad
          openscad
          openscad-lsp
          prusa-slicer
        ];
        js0ny.persist.stores.local.directories = [
          ".config/FreeCAD"
          ".local/share/FreeCAD"
        ];
      })
      (lib.mkIf (pkgs.stdenv.hostPlatform.isDarwin) { js0ny.homebrew.casks = [ ]; })
    ];
}
