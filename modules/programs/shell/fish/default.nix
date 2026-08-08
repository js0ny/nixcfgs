{
  flake.nixosModules.fish = import ./system.nix;
  flake.darwinModules.fish = import ./system.nix;
  flake.homeModules.fish = _: {
    programs.fish.enable = true;
    programs.zed-editor.extensions = [ "fish" ];
    nixdots.persist.home.files = [
      ".local/share/fish/fish_history"
    ];
  };
  flake.nixosModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.nixosModules.fish ];
  };
  flake.homeModules.desktop = { inputs, ... }: {
    imports = [ inputs.self.homeModules.fish ];
  };
  flake.homeModules.darwin = { inputs, ... }: {
    imports = [ inputs.self.homeModules.fish ];
  };
}
