; init-dired.el  -*- lexical-binding: t; -*-

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



(provide 'init-dired)
