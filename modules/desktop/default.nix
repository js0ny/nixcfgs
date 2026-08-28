{
  imports = [
    ./packages.nix
  ];
  flake.nixosModules.desktop =
    {
      pkgs,
      inputs,
      myLib,
      ...
    }:
    {
      imports = [
        inputs.self.nixosModules.core
        inputs.self.nixosModules.nix-index-database
      ]
      ++ myLib.scanPaths ./nixos;
      nixdefs.hardware.enable = true;
      programs.appimage = {
        enable = true;
        package = pkgs.appimage-run.override {
          extraPkgs = pkgs: [
            pkgs.zstd
          ];
        };
      };
    };
  flake.homeModules.desktop = { myLib, ... }: { imports = myLib.scanPaths ./home; };
}
