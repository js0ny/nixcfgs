{
  flake.nixosModules.firefox =
    {
      lib,
      config,
      ...
    }:
    let
      policies = import ./policies.nix;
      baseprefs = import ./global-prefs.nix;
      wsl = config.wsl.enable;
    in
    lib.mkIf (!wsl) {
      programs.firefox = {
        enable = true;
        # package = pkgs.nixpaks.firefox;
        preferences = baseprefs;
        policies = policies;
      };
    };
  flake.homeModules.firefox = import ./home.nix;
}
