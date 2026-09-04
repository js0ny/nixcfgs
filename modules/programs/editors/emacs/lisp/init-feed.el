; init-feed.el  -*- lexical-binding: t; -*- 

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

(use-package hnview
  :custom
  (hnview-translate-target-language "zh-CN")
  (hnview-database-file (expand-file-name "hnview.sqlite" user-emacs-data)))


(provide 'init-feed)
