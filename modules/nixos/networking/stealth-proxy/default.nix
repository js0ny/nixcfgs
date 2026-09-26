{
  flake.nixosModules = {
    clash-verge = import ./clash-verge.nix;
    dae = import ./dae.nix;
    sing-box-desktop = import ./sing-box-desktop.nix;
    throne = import ./throne.nix;
  };
}
