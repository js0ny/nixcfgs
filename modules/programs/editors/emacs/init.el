;; All elisp files under emacs.d/lisp will be loaded
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
  (evil-mode 1))

(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :bind (:map company-active-map
	      ("C-n" . company-select-next)
	      ("C-p" . company-select-previous))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.2))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))


(use-package vertico
  :ensure t
  :config
  (vertico-mode 1))

(use-package avy
  :ensure t
  :after evil
  :config
  (evil-define-key '(normal) 'global (kbd "T") 'avy-goto-char)
  (evil-define-key '(normal) 'global (kbd "s") 'avy-goto-char-2)
  (evil-define-key '(normal) 'global (kbd "S") 'avy-goto-char-2-above))

;; Provides Vim-like Leader key <SPC>
(use-package evil-leader
  :after evil
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
  :ensure t
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
    :ensure t
    :config
    (setq xclip-program "wl-copy")
    (setq xclip-select-enable-clipboard t)
    (setq xclip-mode t)
    (setq xclip-method (quote wl-copy))))


(use-package org
  :custom
  (org-log-done 'time)
  (org-startup-indented nil))

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



(use-package emacs
  :config
  (setq inhibit-startup-message t))

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

(setq transient-history-file (expand-file-name "transient/history.el" user-emacs-data))
(setq transient-values-file (expand-file-name "transient/values.el" user-emacs-data))
(setq transient-levels-file (expand-file-name "transient/levels.el" user-emacs-data))


(use-package eglot
  :config
  (add-to-list 'eglot-server-programs
	       '(nix-ts-mode . ("nixd"))))
(use-package nix-ts-mode
    :mode "\\.nix\\'"
    :hook (nix-ts-mode . eglot-ensure))


(use-package telega
  :ensure t
  :commands (telega)
  :bind (:map telega-chat-mode-map
	      ("C-S-v" . telega-chatbuf-attach-clipboard)
	      ("S-<insert>" . telega-chatbuf-attach-clipboard))
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

(use-package ement :ensure t)

(use-package ghostel
  :bind ("C-x m" . ghostel))

(use-package dashboard :ensure t)


(use-package org-supertag
  :custom
  (supertag-data-directory (expand-file-name "org-supertag" user-emacs-data))
  (org-supertag-sync-directories '("~/org/")))

(use-package elfeed
  :custom
  (elfeed-search-filter "@1-month-ago +unread")
  (elfeed-db-directory (expand-file-name "elfeed" user-emacs-data))
  :config
  (add-to-list 'evil-emacs-state-modes 'elfeed-search-mode)
  (add-to-list 'evil-emacs-state-modes 'elfeed-show-mode))

(use-package elfeed-protocol
  :after elfeed
  :custom
  (elfeed-use-curl t)
  (elfeed-protocol-enabled-protocols '(fever))
  (elfeed-protocol-fever-update-unread-only t))

(use-package doom-modeline
  :config
  (doom-modeline-mode))

(use-package hnview
  :custom
  (hnview-translate-target-language "zh-CN")
  (hnview-database-file (expand-file-name "hnview.sqlite" user-emacs-data)))

(defun org-typst-preview ()
  (interactive)
  (let (checkdir-flag)
    (org-element-map
	(org-element-parse-buffer)
	'(src-block)
      (lambda (bl)
	(when (string= (org-element-property :language bl) "typst")
	  (let* ((start (org-element-property :begin bl))
		 (value (org-element-property :value bl))
		 (end (+ start
			 (length
			  (string-to-list
			   (concat "#+begin_src typst" value "#+end_src\n")))))
		 (fg (plist-get org-format-latex-options :foreground))
		 (hash (sha1 (prin1-to-string (list value fg))))
		 (imagetype "svg")
		 (prefix (concat "typstimg/" "org-typst"))
		 (absprefix (expand-file-name prefix))
		 (linkfile (format "%s_%s.%s" prefix hash imagetype))
		 (movefile (format "%s_%s.%s" absprefix hash imagetype))
		 (sep "\n\n")
		 (link (concat sep "[[file:" linkfile "]]" sep)))
	    (unless checkdir-flag ; Ensure the directory exists.
	      (setq checkdir-flag t)
	      (let ((todir (file-name-directory absprefix)))
		(unless (file-directory-p todir)
		  (make-directory todir t))))
	    (unless (file-exists-p movefile)
	      (with-temp-buffer
		(insert "#set text(size: 30pt, fill: rgb(\"#ebdbb2\"))\n#set page(width: auto, height: auto, margin: 10pt)\n")
		(insert value)
		(let* ((temp-file (make-temp-file ""))
		       (command (format
				 "typst compile %s %s" temp-file movefile)))
		  (write-file temp-file)
		  (shell-command command))))
	    (progn
	      (dolist (o (overlays-in start end))
		(when (eq (overlay-get o 'org-overlay-type)
			  'org-latex-overlay)
		  (delete-overlay o)))
	      (org--make-preview-overlay start end movefile imagetype)
	      (goto-char end))))))))

(use-package magit
  :ensure t)
