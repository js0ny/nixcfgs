{
  flake.nixosModules.fish = import ./system.nix;
  flake.darwinModules.fish = import ./system.nix;
  flake.homeModules.fish = _: {
    programs.fish.enable = true;
    programs.zed-editor.extensions = [ "fish" ];
    js0ny.persist.stores.state.files = [
      ".local/share/fish/fish_history"
    ];
  };
}
