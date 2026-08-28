{
  flake.homeModules.electronics =
    { pkgs, lib, ... }:
    lib.mkMerge [
      (lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) {
        home.packages = with pkgs; [
          kicad
          ltspice
          ngspice
          gtkwave
          picocom
          logisim-evolution
          pulseview
          iverilog
          qucs-s
        ];
        nixdots.persist.nosnap.home = {
          directories = [
            ".config/kicad"
            ".local/share/kicad"

            ".config/ltspice"
          ];
        };
      })
      (lib.mkIf (pkgs.stdenv.hostPlatform.isDarwin) {
        js0ny.homebrew.casks = [
          "ltspice"
          "ngspice"
          "kicad"
        ];
      })
    ];
}
