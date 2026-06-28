{
  flake.nixosModules.audio = import ./audio.nix;
  flake.nixosModules.bluetooth = import ./bluetooth.nix;
  flake.nixosModules.desktop-base = import ./base.nix;
  flake.nixosModules.desktop-sessions = import ./desktop-sessions.nix;
  flake.nixosModules.display-manager = import ./display-manager.nix;
  flake.nixosModules.firmware = import ./firmware.nix;
  flake.nixosModules.gnome-keyring = import ./gnome-keyring.nix;
  flake.nixosModules.gui = import ./gui.nix;
  flake.nixosModules.i2c = import ./i2c.nix;
  flake.nixosModules.input = import ./input.nix;
  flake.nixosModules.lanzaboote = import ./lanzaboote.nix;
  flake.nixosModules.laptop = import ./laptop.nix;
  flake.nixosModules.networkmanager = import ./networkmanager.nix;
  flake.nixosModules.desktop-packages = import ./packages.nix;
  flake.nixosModules.peripherals = import ./peripherals.nix;

  flake.nixosModules.desktop = { inputs, ... }: {
    imports = [
      ./audio.nix
      ./base.nix
      ./bluetooth.nix
      ./desktop-sessions.nix
      ./display-manager.nix
      ./firmware.nix
      ./gnome-keyring.nix
      ./gui.nix
      ./i2c.nix
      ./input.nix
      ./lanzaboote.nix
      ./laptop.nix
      ./networkmanager.nix
      ./packages.nix
      ./peripherals.nix
      inputs.self.nixosModules.cosmic
      inputs.self.nixosModules.hyprland
      inputs.self.nixosModules.mangowc
      inputs.self.nixosModules.niri
      inputs.self.nixosModules.plasma
      inputs.self.nixosModules.sway
    ];
    nixdefs.hardware.enable = true;
    programs.appimage.enable = true;
  };

  flake.homeModules.plasma = import ./home/plasma/module.nix;
  flake.homeModules.hyprland = import ./home/hyprland/module.nix;
  flake.homeModules.niri = import ./home/niri/module.nix;
}
