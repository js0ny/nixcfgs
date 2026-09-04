; init-social.el  -*- lexical-binding: t; -*-

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

(provide 'init-social)
