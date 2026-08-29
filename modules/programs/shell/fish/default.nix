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
}
