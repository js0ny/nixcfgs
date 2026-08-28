{
  imports = [
    ./packages.nix
  ];
  flake.nixosModules.desktop = { pkgs, inputs, ... }: {
    imports = [
      # keep-sorted start
      ./audio.nix
      ./base.nix
      ./bluetooth.nix
      ./coredump-notify.nix
      ./display-manager.nix
      ./firmware.nix
      ./gnome-keyring.nix
      ./gui.nix
      ./i2c.nix
      ./input.nix
      ./lanzaboote.nix
      ./laptop.nix
      ./networkmanager.nix
      ./peripherals.nix
      ./thumbnailers.nix
      ./xdg-portal.nix
      # keep-sorted end
      inputs.self.nixosModules.core
      inputs.self.nixosModules.nix-index-database
    ];
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
}
