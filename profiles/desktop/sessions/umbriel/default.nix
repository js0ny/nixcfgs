{
  flake.nixosModules.umbriel = { inputs, ... }: {
    imports = [ inputs.umbriel.nixosModules.default ];

    programs.umbriel.enable = true;

    home-manager.users.js0ny.xdg.configFile = {

    };
  };
}
