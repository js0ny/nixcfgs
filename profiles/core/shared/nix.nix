{ inputs, config, ... }:
{
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings = {
      trusted-users = [ "@wheel" ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cache.nixos-cuda.org"
        "https://cache.numtide.com"
        "https://js0ny.cachix.org"
        "https://attic.xuyh0120.win/lantian"
        "https://hyprland.cachix.org"
        "https://noctalia.cachix.org"
        "https://sfd-nix.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "js0ny.cachix.org-1:3wFjMGtsxTjJTzE9fT4CgaUCT76rQUh3siumobHQLw0="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "sfd-nix.cachix.org-1:SX5EpvFvgFZXgG94/0fX1L+lUWQ90dPq0Ieor7/rDig="
      ];
      use-xdg-base-directories = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      # TODO: Use different value for different hosts
      max-jobs = config.js0ny.hardware.cpu.nproc / 2;
    };
    registry = rec {
      nixpkgs.flake = inputs.nixpkgs;
      p.flake = nixpkgs.flake;
      nur.flake = inputs.nur;
      js0ny.flake = inputs.js0ny-packages;
      unfree.flake = inputs.nixpkgs-unfree;
    };
  };
}
