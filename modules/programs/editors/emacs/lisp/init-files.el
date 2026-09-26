; init-files.el  -*- lexical-binding: t; -*-

(defvar user-backup-directory (expand-file-name "backups" user-emacs-data))
(defvar user-autosaves-directory (expand-file-name "autosaves" user-emacs-cache))

(use-package auth-source
  :custom
  (auth-sources
   (list (expand-file-name "~/.config/sops-nix/secrets/emacs_authinfo"))))

(use-package recentf
  :custom
  (recentf-save-file (expand-file-name "recentf" user-emacs-data))
  (recentf-auto-cleanup 'never)
  (recentf-exclude '("COMMIT_MSG" "COMMIT_EDITMSG"))
  (recentf-max-saved-items 500))



(dolist (dir (list user-backup-directory user-autosaves-directory))
  (unless (file-exists-p dir)
    (make-directory dir t)
    (message "Creating directory: %s" dir)))

(setq backup-directory-alist `((user-backup-directory)))

(setq project-list-file (expand-file-name "projects-list" user-emacs-data))

(setq auto-save-list-file-prefix
      (expand-file-name "auto-save-list/.saves-" user-autosaves-directory))

;; TRAMP 远程文件的备份设置
(use-package tramp
  :config
  (setq tramp-backup-directory-alist (copy-tree backup-directory-alist))
  (setq tramp-persistency-file-name (expand-file-name "tramp" user-emacs-state)))


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


(use-package eshell
  :ensure t
  :config
  (setq eshell-directory-name (expand-file-name "eshell" user-emacs-data)))

(provide 'init-files)

