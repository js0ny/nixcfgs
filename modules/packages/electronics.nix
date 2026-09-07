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
        js0ny.persist.stores.local.directories = [
          ".config/kicad"
          ".local/share/kicad"

          ".config/ltspice"
        ];
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
