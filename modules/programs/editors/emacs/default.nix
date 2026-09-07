{
  flake.homeModules.emacs =
    {
      pkgs,
      lib,
      config,
      secrets,
      ...
    }:
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
      dots = config.nixdots.core.dots;
      authPath = config.sops.secrets.emacs_authinfo.path;
      secretsPath = config.sops.secrets."emacs_secrets.el".path;
    in
    {
      sops.secrets = {
        emacs_authinfo = {
          sopsFile = secrets + "/files/emacs_authinfo.yaml";
          key = "data";
        };
        "emacs_secrets.el" = {
          sopsFile = secrets + "/files/emacs_secrets.yaml";
          key = "data";
        };
      };
      services.emacs = {
        enable = true;
        package = config.programs.emacs.finalPackage;
        startWithUserSession = "graphical";
      };
      programs.emacs = {
        enable = true;
        package = if pkgs.stdenv.hostPlatform.isLinux then pkgs.emacs-pgtk else null;
        extraConfig = /* lisp */ ''
          (setq org-babel-python-command "${lib.getExe pkgs.python3}")
          (setq dirvish-vipsthumbnail-program "${lib.getExe' pkgs.vips "vipsthumbnail"}")
          (setq dirvish-pdfinfo-program "${lib.getExe' pkgs.poppler-utils "pdfinfo"}")
          (setq dirvish-pdftoppm-program "${lib.getExe' pkgs.poppler-utils "pdftoppm"}")
          (defvar user-authinfo-file (expand-file-name "${authPath}"))

          (defvar user-secrets-file (expand-file-name "${secretsPath}"))
          (when (file-readable-p user-secrets-file)
            (load user-secrets-file nil 'nomessage))
        '';
        extraPackages =
          epkgs:
          with epkgs;
          [
            pkgs.js0ny.emacsPackages.typst-overlay
            pkgs.js0ny.emacsPackages.kitty-graphics

            # display
            dashboard
            highlight-indent-guides
            doom-modeline
            doom-themes

            # enhancement
            evil-ghostel
            ghostel
            company
            vertico
            marginalia
            counsel
            dirvish

            # tools
            magit
            majutsu
            yasnippet
            flycheck
            zoxide

            # evil
            avy
            flash
            evil
            evil-surround
            evil-mc
            evil-goggles
            evil-leader
            evil-commentary

            # org
            olivetti
            org-modern
            org-roam
            org-download
            org-appear
            mixed-pitch

            # social
            ement
            melpaPackages.telega

            # feed
            elfeed
            elfeed-org
            elfeed-protocol

            # typst
            ox-typst
            typst-ts-mode
            typst-preview

            # clients
            hnview

            beancount
            nix-ts-mode
            gptel
            posframe
            ht
            nix-mode
            htmlize

            (epkgs.treesit-grammars.with-grammars (grammars: [
              grammars.tree-sitter-nix
            ]))
          ]
          ++ (lib.optionals pkgs.stdenv.hostPlatform.isLinux [ epkgs.xclip ]);
      };

      xdg.configFile."emacs".source = mkSymlink "${dots}/modules/programs/editors/emacs";
      js0ny.persist.stores = {

        state.directories = [ "org" ];
        local.directories = [ ".local/share/emacs" ];
      };
    };
}
