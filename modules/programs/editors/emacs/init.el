;; -*- lexical-binding: t; -*-
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Store the auto-generated custom config to `custom.el`
(setq package-user-dir (expand-file-name "elpa" user-emacs-data))
(setq custom-file (expand-file-name "custom.el" user-emacs-data))

(set-default-coding-systems 'utf-8)

(require 'init-display)
(require 'init-files)
(require 'init-gui)
(require 'init-tui)
(require 'init-linux)
(require 'init-darwin)
(require 'init-edit)
(require 'init-evil)
(require 'init-counsel)
(require 'init-dired)
(require 'init-org)
(require 'init-lang)
(require 'init-social)
(require 'init-feed)




(add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))
(require 'org-typst-preview)
