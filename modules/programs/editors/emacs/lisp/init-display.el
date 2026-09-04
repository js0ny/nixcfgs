; init-display.el  -*- lexical-binding: t; -*-

(use-package emacs
  :custom
  (inhibit-startup-message t)

  ;; scroll
  (scroll-margin 5)
  (scroll-step 1)
  (hscroll-margin 3)
  (hscroll-step 1)

  ;; startup
  (initial-scratch-message "")
  :config
  (menu-bar-mode -1)
  (tool-bar-mode -1))


(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :custom
  (which-key-idle-delay 0.1))



(use-package display-line-numbers
  :init
  (global-display-line-numbers-mode)
  :custom
  (display-line-numbers-type 'relative)
  (display-line-numbers-current-absolute t)
  :hook
  (prog-mode . display-line-numbers-mode))


(use-package dashboard :ensure t)


(use-package doom-modeline
  :config
  (doom-modeline-mode))

(use-package doom-themes)


(use-package highlight-indent-guides
  :config
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method 'character))

(provide 'init-display)
