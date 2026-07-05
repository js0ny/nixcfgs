{
  flake = {
    nixosModules.dconf-editor = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.dconf-editor ];
    };
    homeModules.dconf-editor = { pkgs, ... }: {
      home.packages = with pkgs; [ dconf-editor ];
      dconf.settings = {
        "ca/desrt/dconf-editor" = {
          show-warning = false;
        };
      };
    };
    nixosModules.desktop = { inputs, ... }: {
      imports = [ inputs.self.nixosModules.dconf-editor ];
    };
    homeModules.desktop = { inputs, ... }: {
      imports = [ inputs.self.homeModules.dconf-editor ];
    };
  };
}
