; init-edit.el  -*- lexical-binding: t; -*- 

(use-package company
  :hook (after-init . global-company-mode)
  :bind (:map company-active-map
	      ("C-n" . company-select-next)
	      ("C-p" . company-select-previous))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.2))


(with-eval-after-load 'company
  (require 'company-childframe))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))


(use-package vertico
  :ensure t
  :config
  (vertico-mode 1))

(use-package yasnippet
  :config
  (yas-global-mode 1)
  :commands yas-minor-mode
  :hook
  ((prog-mode . yas-minor-mode)
   (org-mode . yas-minor-mode)))


(use-package flash
  :after evil
  :config
  (evil-define-key '(normal) 'global (kbd "s") #'flash-jump))


(use-package magit
  :init
  (evil-set-initial-state 'magit-status-mode 'motion)
  :commands (magit)
  :config
  (evil-define-key 'motion magit-status-mode-map
    (kbd "TAB") #'magit-section-toggle
    (kbd "za") #'magit-section-toggle
    (kbd "RET") #'magit-diff-visit-file)
  (evil-leader/set-key
    "g" #'magit))

;; (use-package avy
;;   :after evil
;;   :config
;;   (evil-define-key '(normal) 'global (kbd "T") 'avy-goto-char)
;;   (evil-define-key '(normal) 'global (kbd "s") 'avy-goto-char-2)
;;   (evil-define-key '(normal) 'global (kbd "S") 'avy-goto-char-2-above))


(provide 'init-edit)
