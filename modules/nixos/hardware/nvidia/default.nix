{
  flake.nixosModules.nvidia = _: {
    imports = [
      ./nvidia-disable.nix
      ./nvidia-enable.nix
      ./nvidia-vfio.nix
    ];
  };
}
