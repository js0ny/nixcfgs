{
  flake.nixosModules.umbriel = { inputs, pkgs, ... }: {
    imports = [ inputs.umbriel.nixosModules.default ];

    programs.umbriel = {
      enable = true;
      package = inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };
}
