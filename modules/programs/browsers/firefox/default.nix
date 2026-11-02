{
  flake.nixosModules.firefox =
    {
      lib,
      config,
      inputs,
      ...
    }:
    let
      baseprefs = import ./global-prefs.nix;
      wsl = config.wsl.enable;
      sharedPath = "${inputs.self.outPath}/migrated/shared-modules/firefox";
      policies = import "${sharedPath}/policies/vanilla.nix";
    in
    lib.mkIf (!wsl) {
      programs.firefox = {
        enable = true;
        # package = pkgs.nixpaks.firefox;
        preferences = baseprefs;
        policies = policies // {
          "3rdparty".Extensions = {
            "{3c078156-979c-498b-8990-85f7987dd929}" = import ./sidebery.nix;
            "uBlock0@raymondhill.net" = import "${sharedPath}/policies/ublock-origin.nix";
            "containerise-managed@js0ny.net" = import "${sharedPath}/policies/containerise.nix";
          };
        };
      };
    };
  flake.homeModules.firefox = import ./home.nix;
}
