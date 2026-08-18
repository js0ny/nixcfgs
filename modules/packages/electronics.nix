{
  flake.nixosModules.electronics = _: {
    users.groups."dialout" = { };
  };
  flake.homeModules.electronics =
    { pkgs, lib, ... }:
    lib.mkMerge [
      (lib.mkIf (pkgs.stdenv.isLinux) {
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
      (lib.mkIf (pkgs.stdenv.isDarwin) {
        js0ny.homebrew.casks = [
          "ltspice"
          "ngspice"
          "kicad"
        ];
      })
    ];
}
