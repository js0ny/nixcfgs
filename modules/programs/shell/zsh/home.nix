{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    zsh-fzf-tab
    zsh-nix-shell
  ];
  programs.zsh = {
    enable = true;
    # oh-my-zsh.enable = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    enableCompletion = true;
    dotDir = "${config.xdg.configHome}/zsh";
    defaultKeymap = "emacs";
    # zsh-abbr = {
    #   enable = true;
    #   abbreviations = aliases;
    # };

    history = {
      ignorePatterns = [
        "tmp"
        "Authorization:"
      ];
    };

    initContent = /* zsh */ ''
      # Misc
      # ==========
      # Remove / from word characters, for easier path navigation (using backward-word, forward-word, etc)
      export WORDCHARS=''${WORDCHARS//\//}
      export WORDCHARS=''${WORDCHARS//\#/}

      # Options
      # ==========

      setopt INTERACTIVE_COMMENTS # Allow comments in interactive mode

      # Globbing
      setopt EXTENDED_GLOB        # Extended globbing
      # setopt GLOB_DOTS            # Include dotfiles in globbing

      # Error correction
      # setopt CORRECT              # Suggest corrections for commands
      # setopt CORRECT_ALL          # Suggest corrections for arguments
    '';
  };
}
