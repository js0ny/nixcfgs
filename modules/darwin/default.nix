{
  flake.darwinModules.brew = import ./brew.nix;
  flake.darwinModules.darwin-core = import ./core.nix;
  flake.darwinModules.determinate = import ./determinate.nix;
  flake.darwinModules.finder = import ./finder.nix;
  flake.darwinModules.pam = import ./pam.nix;
  flake.darwinModules.stylix = import ./stylix.nix;

  flake.darwinModules.darwin =
    { inputs, ... }:
    {
      imports = [
        ./brew.nix
        ./core.nix
        ./determinate.nix
        ./finder.nix
        ./pam.nix
        ./stylix.nix
        inputs.self.darwinModules.sshd
        inputs.self.darwinModules.tailscale
      ];
    };
}
