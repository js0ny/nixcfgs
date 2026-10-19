{ pkgs, ... }:
let
  batp = lang: ''piper -- bat --plain --color=always --language=${lang} "$1"'';
in
{
  programs.bat = {
    enable = true;
    syntaxes = {
      # keep-sorted start block=yes
      fennel.src = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/gbaptista/sublime-text-fennel/442985630f16fa565b4e8d52571e78f395a5a28d/Fennel.sublime-syntax";
        hash = "sha256-6RojRSfqDLqU9I5kEknWhTeRhqhDTP+t3v//nA6xBuc=";
      };
      just.src = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/nk9/just_sublime/refs/heads/main/Syntax/Just.sublime-syntax";
        hash = "sha256-mbpEWzr0+HpRpc0jTFFHE7yiUsmmdBuBXR/BHZpQSxk=";
      };
      nushell.src = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/kurokirasama/nushell_sublime_syntax/refs/heads/main/nushell.sublime-syntax";
        hash = "sha256-K6VO+Y9qTgpRup3oqLrHzgRG9y0aS06O1fPB1bNV44U=";
      };
      # keep-sorted end
    };
  };
  home.sessionVariables = {
    MANPAGER = ''sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman' '';
    NIX_PAGER = "bat --style grid,numbers --wrap auto";
  };

  programs.yazi.settings.plugin.prepend_previewers = [
    {
      url = "*.fnl";
      run = batp "fennel";
    }
    {
      url = "*.nu";
      run = batp "nushell";
    }
    {
      url = "justfile";
      run = batp "just";
    }
  ];
}
