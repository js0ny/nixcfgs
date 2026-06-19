{ config, inputs, ... }:
let
  username = config.nixdots.user.name;
in
{
  nix = {
    settings = {
      trusted-users = [
        "${username}"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://attic.xuyh0120.win/lantian"
        "https://cache.numtide.com"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        # "conduwuit:BbycGUgTISsltcmH0qNjFR9dbrQNYgdIAcmViSGoVTE="
      ];
      use-xdg-base-directories = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      nur.flake = inputs.nur;
      js0ny.flake = inputs.nix-misc-packages;
      unfree.flake = inputs.nixpkgs-unfree;
    };
  };
}
