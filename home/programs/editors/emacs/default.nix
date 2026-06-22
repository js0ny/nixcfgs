# emacs: Currently for telegram only.
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
      let
        org-supertag = epkgs.trivialBuild {
          pname = "org-supertag";
          version = "5.8.2-unstable-2026-06-19";
          src = pkgs.fetchFromGitHub {
            owner = "yibie";
            repo = "org-supertag";
            rev = "ff45a9616aaecfbbfc4081715a86dd9612b8b28d";
            hash = "sha256-NA8Rj6gMYF21PdIsxM4clZ3JVezUXJquG3ojNq0HWgM=";
          };
          postPatch = /* bash */ ''
            substituteInPlace supertag-services-capture.el \
              --replace-fail '(lambda (t) (concat "#" t))' '(lambda (tag) (concat "#" tag))'
            substituteInPlace supertag-ui-completion.el \
              --replace-fail '(lambda (t) (member t current))' '(lambda (tag) (member tag current))'
          '';
          packageRequires = with epkgs; [
            gptel
            ht
            org
            posframe
          ];
        };
      in
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
        gptel
        posframe
        ht
        org-supertag
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

  nixdots.persist.nosnap.home.directories = [ ".local/share/emacs" ];
}
