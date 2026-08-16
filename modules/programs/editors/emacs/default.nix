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
        extraConfig = /* elisp */ ''
          (setq org-babel-python-command "${lib.getExe pkgs.python3}")
        '';
        extraPackages =
          epkgs:
          with epkgs;
          [
            pkgs.js0ny.emacsPackages.typst-overlay
            pkgs.js0ny.emacsPackages.kitty-graphics
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
            doom-modeline
            gptel
            posframe
            ht
            yasnippet
            nix-mode
            htmlize
            (epkgs.treesit-grammars.with-grammars (grammars: [
              grammars.tree-sitter-nix
            ]))
          ]
          ++ (lib.optionals pkgs.stdenv.isLinux [ epkgs.xclip ]);
      };

      home.directories.org = {
        create = true;
        persist = true;
      };

      xdg.configFile."emacs".source = mkSymlink "${dots}/modules/programs/editors/emacs";

      nixdots.persist.nosnap.home.directories = [ ".local/share/emacs" ];
    };
}
