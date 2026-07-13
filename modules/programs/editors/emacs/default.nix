{
  flake.homeModules.emacs =
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
            hnview = epkgs.trivialBuild {
              pname = "hnview";
              version = "0.1.0";

              src = pkgs.fetchFromGitHub {
                owner = "LuciusChen";
                repo = "hnview";
                rev = "1876200ad573c41e8b14bcb66a236182d13ced35";
                hash = "sha256-JK9sS12D/BIhds15rCdswJD2B8vD7B8NHMZJFVyi6k8=";
              };

              packageRequires = with epkgs; [
                llm
                plz
              ];

              meta = with lib; {
                description = "Modern Emacs-native Hacker News reader with LLM-assisted translation";
                homepage = "https://github.com/LuciusChen/hnview";
                license = licenses.gpl3Plus;
              };
            };
          in
          with epkgs;
          [

            org-supertag
            hnview

            avy
            elfeed-protocol
            dashboard
            evil
            counsel
            evil-leader
            evil-commentary
            evil-surround
            evil-mc
            evil-goggles
            evil-org
            ement
            melpaPackages.telega
            # ghostel
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
            (epkgs.treesit-grammars.with-grammars (grammars: [
              grammars.tree-sitter-nix
            ]))
          ]
          ++ (lib.optionals pkgs.stdenv.isLinux [ epkgs.xclip ]);
      };

      nixdots.darwin.homebrew = {
        taps = [ "railwaycat/emacsmacport" ];
      };

      xdg.configFile."emacs".source = mkSymlink "${dots}/modules/programs/editors/emacs";

      nixdots.persist.nosnap.home.directories = [ ".local/share/emacs" ];
    };
}
