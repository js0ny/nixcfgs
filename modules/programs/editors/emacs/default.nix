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
        package = if pkgs.stdenv.hostPlatform.isLinux then pkgs.emacs-pgtk else null;
        extraConfig = /* elisp */ ''
          (setq org-babel-python-command "${lib.getExe pkgs.python3}")
          (setq dirvish-vipsthumbnail-program "${lib.getExe' pkgs.vips "vipsthumbnail"}")
          (setq dirvish-pdfinfo-program "${lib.getExe' pkgs.poppler-utils "pdfinfo"}")
          (setq dirvish-pdftoppm-program "${lib.getExe' pkgs.poppler-utils "pdftoppm"}")
        '';
        extraPackages =
          epkgs:
          with epkgs;
          [
            pkgs.js0ny.emacsPackages.typst-overlay
            pkgs.js0ny.emacsPackages.kitty-graphics

            avy
            elfeed-protocol
            dashboard
            hnview
            evil
            counsel
            flash
            evil-leader
            evil-commentary
            zoxide
            evil-surround
            evil-mc
            evil-goggles
            evil-ghostel
            ement
            melpaPackages.telega
            ghostel
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
            org-modern
            doom-modeline
            gptel
            posframe
            ht
            yasnippet
            nix-mode
            htmlize

            ox-typst
            typst-ts-mode
            typst-preview
            (epkgs.treesit-grammars.with-grammars (grammars: [
              grammars.tree-sitter-nix
            ]))
          ]
          ++ (lib.optionals pkgs.stdenv.hostPlatform.isLinux [ epkgs.xclip ]);
      };

      home.directories.org = {
        create = true;
        persist = true;
      };

      xdg.configFile."emacs".source = mkSymlink "${dots}/modules/programs/editors/emacs";

      nixdots.persist.nosnap.home.directories = [ ".local/share/emacs" ];
    };
}
