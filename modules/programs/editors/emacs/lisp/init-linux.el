; init-linux.el  -*- lexical-binding: t; -*-

(when (getenv "WAYLAND_DISPLAY")
  (use-package xclip
    :config
    (setq xclip-program "wl-copy")
    (setq xclip-select-enable-clipboard t)
    (setq xclip-mode t)
    (setq xclip-method (quote wl-copy))))


(provide 'init-linux)
