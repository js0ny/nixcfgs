; init-lang.el  -*- lexical-binding: t; -*-

(defvar sys-flake "(builtins.getFlake \"github:js0ny/nixcfgs\")")

(use-package eglot
  :config
  (add-to-list 'eglot-server-programs
	       '(nix-ts-mode . ("nixd"))
	       '(nix-mode . ("nixd"))))

(use-package nix-mode)

(use-package nix-ts-mode
    :mode "\\.nix\\'"
    :hook (nix-ts-mode . eglot-ensure))


(provide 'init-lang)
