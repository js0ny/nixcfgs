{
  pkgs,
  lib,
  config,
  ...
}:
let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dots = config.nixdots.core.dots;
in
{
  programs.emacs = {
    enable = true;
    package = if pkgs.stdenv.isLinux then pkgs.emacs-pgtk else null;
    extraPackages =
      epkgs:
      with epkgs;
      [
        avy
        dashboard
        evil
        counsel
        evil-leader
        evil-commentary
        evil-surround
        evil-mc
        evil-goggles
        ement
        melpaPackages.telega
        melpaPackages.ghostel
        beancount
        counsel
        company
        vertico
        marginalia
        dirvish
        nix-ts-mode
        flycheck
        highlight-indent-guides
        magit
        elfeed
        elfeed-org
        olivetti
        org-modern
        doom-modeline
        (epkgs.treesit-grammars.with-grammars (grammars: [
          grammars.tree-sitter-nix
        ]))
      ]
      ++ (lib.optionals pkgs.stdenv.isLinux [ epkgs.xclip ]);
  };

  nixdots.darwin.homebrew = {
    taps = [ "railwaycat/emacsmacport" ];
  };

  imports = [ ../. ];
  xdg.configFile."emacs".source = mkSymlink "${dots}/home/programs/editors/emacs";
}
