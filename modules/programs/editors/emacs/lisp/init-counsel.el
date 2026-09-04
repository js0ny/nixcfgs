; init-counsel.el  -*- lexical-binding: t; -*-

(defun js0ny/open-config-directory ()
  "Open `user-emacs-directory` using `counsel-find-file`."
  (interactive)
  (let ((default-directory user-emacs-directory))
    (counsel-file-jump)))

(defun js0ny/open-org-directory ()
  "Open `org-directory` using `counsel-find-file`."
  (interactive)
  (let ((default-directory org-directory))
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


(provide 'init-counsel)
