; init-gui.el init-linux.el  -*- lexical-binding: t; -*-

(when window-system
  (setq initial-frame-alist '((name . "emacs")))
  (setq use-default-font-for-symbols nil)
  (set-fontset-font t 'emoji "Noto Color Emoji-12")
  (dolist (charset '(kana han cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font) charset
			(font-spec :family "HarmonyOS Sans"))))


(use-package ghostel
  :commands (ghostel)
  :bind ("C-x m" . ghostel))

(use-package evil-ghostel
  :after (evil ghostel)
  :hook (ghostel-mode . evil-ghostel-mode))


(provide 'init-gui)
