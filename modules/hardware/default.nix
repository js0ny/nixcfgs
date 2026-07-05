{
  flake.nixosModules.hardware =
    { inputs, ... }:
    {
      imports = [
        inputs.self.nixosModules.hid
        inputs.self.nixosModules.howdy
        inputs.self.nixosModules.nvidia
        inputs.self.nixosModules.serial
      ];

      hardware.enableRedistributableFirmware = true;
    };

  flake.nixosModules.hid = import ./hid.nix;
  flake.nixosModules.howdy = import ./howdy.nix;
  flake.nixosModules.serial = import ./serial.nix;
}
