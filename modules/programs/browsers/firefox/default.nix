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
        policies = policies // {
          "3rdparty".Extensions = {
            "uBlock0@raymondhill.net" = import ./ublock-origin.nix;
            "{3c078156-979c-498b-8990-85f7987dd929}" = import ./sidebery.nix;
            "containerise-managed@js0ny.net" = import ./containerise.nix;
          };
        };
      };
    };
  flake.homeModules.firefox = import ./home.nix;
}
