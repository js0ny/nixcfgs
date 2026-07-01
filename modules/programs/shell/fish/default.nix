{
  flake.nixosModules.fish = import ./system.nix;
  flake.darwinModules.fish = import ./system.nix;
  flake.homeModules.fish = _: {
    programs.fish = {
      enable = true;
      interactiveShellInit = /* fish */ ''
        function tv
            touch $argv[1] && $EDITOR $argv[1]
        end

        if set -q TERM_PROGRAM; and test "$TERM_PROGRAM" = "konsole"
            bind -M insert ctrl-h backward-kill-word
        end
      '';
      # preferAbbrs = true;
    };
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
}
