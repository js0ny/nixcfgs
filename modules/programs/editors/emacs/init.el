;; -*- lexical-binding: t; -*-
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Store the auto-generated custom config to `custom.el`
(setq package-user-dir (expand-file-name "elpa" user-emacs-data))
(setq custom-file (expand-file-name "custom.el" user-emacs-data))

(set-default-coding-systems 'utf-8)


(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super))

(when window-system
  (setq initial-frame-alist '((name . "emacs")))
  (setq use-default-font-for-symbols nil)
  (set-fontset-font t 'emoji "Noto Color Emoji-12")
  (dolist (charset '(kana han cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font) charset
			(font-spec :family "HarmonyOS Sans"))))



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

(use-package recentf
  :custom
  (recentf-save-file (expand-file-name "recentf" user-emacs-data))
  (recentf-auto-cleanup 'never)
  (recentf-exclude '("COMMIT_MSG" "COMMIT_EDITMSG"))
  (recentf-max-saved-items 500))



(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :custom
  (which-key-idle-delay 0.1))


(use-package evil
  :ensure t
  :config
  (evil-mode 1)
					; % match pairs
  (evil-define-key '(normal) 'global (kbd "TAB") 'evil-jump-item))


(use-package company
  :hook (after-init . global-company-mode)
  :bind (:map company-active-map
	      ("C-n" . company-select-next)
	      ("C-p" . company-select-previous))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.2))


(with-eval-after-load 'company
  (require 'company-childframe))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))


(use-package vertico
  :ensure t
  :config
  (vertico-mode 1))

;; Provides Vim-like Leader key <SPC>
(use-package evil-leader
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    "b" #'switch-to-buffer))

;; Evil Commentary: Use gc<action> to toggle comments
(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

;; Evil Surround: Vim-surround Evil fork
(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-mc
  :config
  (global-evil-mc-mode 1))


;; Evil-goggles: Highlight-yank (and more)
(use-package evil-goggles
  :after evil
  :config
  (evil-goggles-mode)

  ;; optionally use diff-mode's faces; as a result, deleted text
  ;; will be highlighed with `diff-removed` face which is typically
  ;; some red color (as defined by the color theme)
  ;; other faces such as `diff-added` will be used for other actions
  (evil-goggles-use-diff-faces))

(with-eval-after-load 'evil
  (evil-set-initial-state 'org-agenda-mode 'motion))


(when (getenv "WAYLAND_DISPLAY")
  (use-package xclip
    :config
    (setq xclip-program "wl-copy")
    (setq xclip-select-enable-clipboard t)
    (setq xclip-mode t)
    (setq xclip-method (quote wl-copy))))


(use-package org
  :custom
  (org-confirm-babel-evaluate nil)
  (org-directory (expand-file-name "~/org"))
  :config
  (require 'org-tempo)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)))
  (add-hook 'org-insert-heading-hook #'org-id-get-create)
  (setq org-id-locations-file (expand-file-name "org-id-locations" user-emacs-data)))

(use-package yasnippet
  :config
  (yas-global-mode 1)
  :commands yas-minor-mode
  :hook
  ((prog-mode . yas-minor-mode)
   (org-mode . yas-minor-mode)))

(use-package eshell
  :ensure t
  :config
  (setq eshell-directory-name (expand-file-name "eshell" user-emacs-data)))


(use-package display-line-numbers
  :init
  (global-display-line-numbers-mode)
  :custom
  (display-line-numbers-type 'relative)
  (display-line-numbers-current-absolute t)
  :hook
  (prog-mode . display-line-numbers-mode))

(defun js0ny/open-config-directory ()
  "Open `user-emacs-directory` using `counsel-find-file`."
  (interactive)
  (let ((default-directory user-emacs-directory))
    (counsel-file-jump)))


(use-package counsel
  :config
  (counsel-mode 1)
  (global-set-key (kbd "C-x C-f") #'counsel-find-file)
  (global-set-key (kbd "M-x") #'counsel-M-x)
  (global-set-key (kbd "C-x d") #'counsel-dired)
  (evil-leader/set-key
    "SPC" #'counsel-file-jump
    "/" #'counsel-rg
    ";" #'counsel-M-x
    "fc" #'js0ny/open-config-directory
    "fh" #'counsel-recentf))


(defvar user-backup-directory (expand-file-name "backups" user-emacs-data))
(defvar user-autosaves-directory (expand-file-name "autosaves" user-emacs-cache))

(dolist (dir (list user-backup-directory user-autosaves-directory))
  (unless (file-exists-p dir)
    (make-directory dir t)
    (message "Creating directory: %s" dir)))

(setq backup-directory-alist `(("." . ,user-backup-directory)))

(setq project-list-file (expand-file-name "projects-list" user-emacs-data))

(setq auto-save-list-file-prefix
      (expand-file-name "auto-save-list/.saves-" user-autosaves-directory))

;; TRAMP 远程文件的备份设置
(setq tramp-backup-directory-alist (copy-tree backup-directory-alist))
(setq tramp-persistency-file-name (expand-file-name "tramp" user-emacs-state))


;; 备份设置
(setq backup-by-copying t      ; 使用复制而非重命名
      delete-old-versions t    ; 自动删除旧版本
      kept-new-versions 6      ; 保留的新版本数量
      kept-old-versions 2      ; 保留的旧版本数量
      version-control t)       ; 使用版本号

(use-package transient
  :custom
  (transient-history-file (expand-file-name "transient/history.el" user-emacs-data))
  (transient-values-file (expand-file-name "transient/values.el" user-emacs-data))
  (transient-levels-file (expand-file-name "transient/levels.el" user-emacs-data)))

(defvar sys-flake "(builtins.getFlake \"github:js0ny/nixcfgs\")")

(use-package eglot
  :config
  (add-to-list 'eglot-server-programs
	       '(nix-ts-mode . ("nixd"))
	       '(nix-mode . ("nixd"))))

(use-package nix-ts-mode
    :mode "\\.nix\\'"
    :hook (nix-ts-mode . eglot-ensure))


(use-package telega
  :commands (telega)
  :custom
  (telega-directory (expand-file-name "telega" user-emacs-data))
  (telega-cache-dir (expand-file-name "telega" user-emacs-cache))
  (telega-temp-dir (expand-file-name "temp" telega-directory))
  (telega-server-logfile (expand-file-name "server.log" telega-directory))
  (telega-voip-logfile (expand-file-name "voip.log" telega-directory))
  (telega-database-dir (expand-file-name "telega" user-emacs-data))
  (telega-msg-save-dir (expand-file-name "~/Downloads"))
  (telega-emoji-font-family "Noto Color Emoji")
  (telega-emoji-use-images nil)
  (telega-chat-input-markups '("markdown2" "org"))
  (telega-accounts (list
		        (list "main"
			       'telega-database-dir (expand-file-name "main" telega-database-dir))
			 (list "site"
			       'telega-database-dir (expand-file-name "site" telega-database-dir))))
  ;(telega-video-player-command (concat "mpv --keep-open=no --idle=no"
  ;      (when telega-ffplay-media-timestamp
  ;        (format " --start=%f" telega-ffplay-media-timestamp))))
  :config
  (add-to-list 'evil-emacs-state-modes 'telega-image-mode)
  (add-hook 'telega-root-mode-hook #'telega-notifications-mode)
  (evil-define-key 'normal telega-chat-mode-map
    (kbd "@") 'telega-chatbuf-attach-inline-bot-query
    (kbd "P") 'telega-chatbuf-attach-clipboard
    (kbd "#") 'telega-chatbuf-attach-sticker)
  (evil-leader/set-key-for-mode 'telega-chat-mode
    "P" 'telega-chatbuf-attach-clipboard))

(use-package ement)

(with-eval-after-load 'ement
  (require 'ement-room-list))

(use-package ghostel
  :commands (ghostel)
  :bind ("C-x m" . ghostel))

(use-package evil-ghostel
  :after (evil ghostel)
  :hook (ghostel-mode . evil-ghostel-mode))

(use-package dashboard :ensure t)


(use-package elfeed
  :commands (elfeed)
  :custom
  (elfeed-search-filter "@1-month-ago +unread")
  (elfeed-db-directory (expand-file-name "elfeed" user-emacs-data))
  :config
  (add-to-list 'evil-emacs-state-modes '(elfeed-search-mode
					 elfeed-show-mode)))

(use-package elfeed-protocol
  :after elfeed
  :custom
  (elfeed-use-curl t)
  (elfeed-protocol-enabled-protocols '(fever))
  (elfeed-protocol-fever-update-unread-only t)
  (elfeed-feeds
    '(("fever+https://js0ny@forge.js0ny.net"
         :api-url "https://forge.js0ny.net/plugins/fever/"
         :use-authinfo t))))

(use-package doom-modeline
  :config
  (doom-modeline-mode))

(use-package hnview
  :custom
  (hnview-translate-target-language "zh-CN")
  (hnview-database-file (expand-file-name "hnview.sqlite" user-emacs-data)))

(use-package magit
  :commands (magit)
  :config
  (evil-define-key '(normal) magit-status-mode-map
    (kbd "<tab>") #'magit-section-toggle
    (kbd "za") #'magit-section-toggle)
  (evil-leader/set-key
    "g" #'magit))


(use-package highlight-indent-guides
  :config
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method 'character))

(use-package auth-source
  :ensure nil
  :custom
  (auth-sources
   (list (expand-file-name "authinfo.gpg"
                           user-emacs-directory))))

(use-package typst-overlay
  :hook ((typst-ts-mode . typst-overlay-mode)
	 (org-mode . typst-overlay-mode)
	 (after-save . typst-overlay-save-refresh)))

(use-package kitty-graphics
 :config
  (kitty-graphics-setup))

(use-package nix-mode)

;; TODO: Reimplement the whole typst overlay
(with-eval-after-load 'typst-overlay
  (defun my/typst-overlay-analyze-org ()
    (let (math-nodes)
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward "\\$[^$]+\\$" nil t)
          (let* ((beg (match-beginning 0))
                 (end (match-end 0))
                 (text (match-string-no-properties 0)))
            (push
             (make-typst-overlay-math-node
              :beg beg
              :end end
              :text text
              :text-hash (md5 text))
             math-nodes))))
      (make-typst-overlay-analysis
       :code-nodes nil
       :math-nodes
       (typst-overlay--sort-math-nodes
        (nreverse math-nodes))
       :first-error nil)))

  (advice-add 'typst-overlay--analyze-org
              :override
              #'my/typst-overlay-analyze-org))

(defvar download-dir
  (or (getenv "XDG_DOWNLOAD_DIR")
      (expand-file-name "~/Downloads")))

(use-package dirvish
  :custom
  (dirvish-cache-dir (expand-file-name "dirvish" user-emacs-cache))
  (dirvish-quick-access-entires
   '(("h" "~/" "Home")
     ("d" download-dir "Downloads")))
  :config
  (dirvish-override-dired-mode))

(use-package zoxide
  :config
  (evil-leader/set-key
    "pd" #'zoxide-cd))



(use-package org-modern
  :ensure t
  :config
  ;; (setopt org-modern-star 'replace
  ;;         org-modern-replace-stars '("§")
  ;;         org-modern-hide-stars "§")
  (setopt org-modern-list '((?- . "•")))
  (setopt org-modern-timestamp '(" %Y-%m-%d " . " %H:%M "))
  (setopt org-modern-block-fringe nil)

;; https://github.com/neoheartbeats/.emacs.d/blob/main/lisp/init-org.el#L126C1-L159C47
  (defun sthenno/org-modern-spacing ()
    "Adjust line-spacing for `org-modern' to correct svg display."

    ;; FIXME: This may not set properly
    (setq-local line-spacing (cond ((eq major-mode #'org-mode) 0.20)
                                   (t nil))))
  (add-hook 'org-mode-hook #'sthenno/org-modern-spacing)


  ;; Hooks
  (add-hook 'org-mode-hook #'org-modern-mode))

(use-package ox-typst)

(use-package olivetti
  :config
  (add-hook 'org-mode-hook #'olivetti-mode))

(use-package flash
  :after evil
  :config
  (evil-define-key '(normal) 'global (kbd "s") #'flash-jump))


;; (use-package avy
;;   :ensure t
;;   :after evil
;;   :config
;;   (evil-define-key '(normal) 'global (kbd "T") 'avy-goto-char)
;;   (evil-define-key '(normal) 'global (kbd "s") 'avy-goto-char-2)
;;   (evil-define-key '(normal) 'global (kbd "S") 'avy-goto-char-2-above))

(use-package org-roam
  :after org
  :custom
  (org-roam-directory (expand-file-name "~/Documents/roam"))
  (org-roam-db-location (expand-file-name "org-roam.db" user-emacs-data))
  :config
  (org-roam-db-autosync-mode))


(add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))
(require 'org-typst-preview)
