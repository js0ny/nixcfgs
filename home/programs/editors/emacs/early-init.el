(setq package-enable-at-startup nil)

(defvar xdg-data-home
  (or (getenv "XDG_DATA_HOME")
      (expand-file-name "~/.local/share")))

(defvar xdg-cache-home
  (or (getenv "XDG_CACHE_HOME")
      (expand-file-name "~/.cache")))

(defvar xdg-state-home
  (or (getenv "XDG_STATE_HOME")
      (expand-file-name "~/.local/state/")))

(defvar user-emacs-data (expand-file-name "emacs" xdg-data-home))
(defvar user-emacs-cache (expand-file-name "emacs" xdg-cache-home))
(defvar user-emacs-state (expand-file-name "emacs" xdg-state-home))

;; Keep native compilation cache out of ~/.config/emacs.
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache
   (expand-file-name "eln-cache/" user-emacs-data)))
