;;; init.el --- Entry point of GNU/Emacs configuration
;;; First edit date 2025/01/27

;;; Organised by such directory structure
;;; init.el -- This file, entry point
;;; lisp/
;;;      init-*.el
;;; custom.el -- Auto Generated
;;; local.el -- Local variables

(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-data))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode))


;; All elisp files under emacs.d/lisp will be loaded
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Store the auto-generated custom config to `custom.el`
(setq package-user-dir (expand-file-name "elpa" user-emacs-data))
(setq custom-file (expand-file-name "custom.el" user-emacs-data))

(set-default-coding-systems 'utf-8)


(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super))

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
    "ft" #'treemacs
    "bb" #'buffer-menu))

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
  :custom
  (telega-directory (expand-file-name "telega" user-emacs-data))
  (telega-cache-dir (expand-file-name "telega" user-emacs-cache))
  (telega-temp-dir (expand-file-name "temp" telega-directory))
  (telega-server-logfile (expand-file-name "server.log" telega-directory))
  (telega-voip-logfile (expand-file-name "voip.log" telega-directory))
  (telega-database-dir (expand-file-name "telega" user-emacs-data)))
