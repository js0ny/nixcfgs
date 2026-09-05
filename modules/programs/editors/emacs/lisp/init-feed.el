; init-feed.el  -*- lexical-binding: t; -*-

(setq url-cache-directory (expand-file-name "url/cache" user-emacs-cache))

(use-package elfeed
  :commands (elfeed)
  :init
  (evil-set-initial-state 'elfeed-search-mode 'motion)
  (evil-set-initial-state 'elfeed-show-mode 'motion)
  :custom
  (elfeed-search-filter "@1-month-ago +unread")
  (elfeed-db-directory (expand-file-name "elfeed" user-emacs-data))
  :config
  (evil-define-key 'motion 'elfeed-search-mode-map (kbd "RET") #'elfeed-search-show-entry))

(use-package elfeed-protocol
  :after elfeed
  :custom
  (elfeed-use-curl t)
  (elfeed-protocol-enabled-protocols '(fever))
  (elfeed-protocol-fever-update-unread-only t)
  (elfeed-feeds
    ;; lies in secrets.el
    `((,miniflux-fever-account
         :api-url ,miniflux-fever-url
         :use-authinfo t)))
  :config
  (elfeed-protocol-enable))

(use-package hnview
  :commands (hnview)
  :init
  (evil-set-initial-state 'hnview-feed-mode 'motion)
  (evil-set-initial-state 'hnview-thread-mode 'motion)
  :custom
  (hnview-translate-target-language "zh-CN")
  (hnview-database-file (expand-file-name "hnview.sqlite" user-emacs-data))
  :config
  (evil-define-key 'motion 'hnview-feed-mode-map
    (kbd "j") #'hnview-next-item
    (kbd "k") #'hnview-previous-item
    (kbd "RET") #'hnview-open-item))



(provide 'init-feed)
