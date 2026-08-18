{
  flake.homeModules.engineering =
    { pkgs, lib, ... }:
    lib.mkMerge [
      (lib.mkIf (pkgs.stdenv.isLinux) {
        home.packages = with pkgs; [
          # freecad
          openscad
          openscad-lsp
          prusa-slicer
        ];
        nixdots.persist.nosnap.home = {
          directories = [
            ".config/FreeCAD"
            ".local/share/FreeCAD"
          ];
        };
      })
      (lib.mkIf (pkgs.stdenv.isDarwin) { js0ny.homebrew.casks = [ ]; })
    ];
}
