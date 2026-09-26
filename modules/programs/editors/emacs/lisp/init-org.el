; init-org.el  -*- lexical-binding: t; -*-

(defun js0ny/insert-emphasis-with-zws (char)
  (interactive "c")
  (insert ?\u200B char)
  (save-excursion (insert char ?\u200B)))


(use-package org
  :custom
  (org-confirm-babel-evaluate nil)
  (org-directory (expand-file-name "~/org"))
  :config
  (require 'org-tempo)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)))
  (add-hook 'org-insert-heading-hook #'org-id-get-create)
  (setq org-id-locations-file (expand-file-name "org-id-locations" user-emacs-data))
  (dolist (face '((org-level-1 . 1.3)
                  (org-level-2 . 1.2)
                  (org-level-3 . 1.1)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.0)
                  (org-level-6 . 1.0)
                  (org-level-7 . 1.0)
                  (org-level-8 . 1.0)))
    (set-face-attribute (car face) nil :height (cdr face)))
  (evil-define-key 'normal org-mode-map (kbd "TAB") 'org-cycle)
  (setq org-agenda-files (list (expand-file-name "tasks/" org-directory)))
  (evil-leader/set-key
    "a" #'org-agenda-list
    "A" #'org-agenda
    "o" #'js0ny/open-org-directory)
  (setq org-icalendar-use-scheduled '(event-if-todo event-if-not-todo))
  (setq org-icalendar-use-deadline '(event-if-todo event-if-not-todo))
  (setq org-log-into-drawer "LOGBOOK")
  (setq org-src-tab-acts-natively t) ; Use TAB to indent inside codeblock
  (setq org-startup-folded 'showall))

(with-eval-after-load 'evil
  (evil-set-initial-state 'org-agenda-mode 'motion))


(use-package org-appear
  :after org
  :hook (org-mode . org-appear-mode)
  :init
  (setq org-hide-emphasis-markers t))


(use-package typst-overlay
  :hook ((typst-ts-mode . typst-overlay-mode)
	 (org-mode . typst-overlay-mode)
	 (after-save . typst-overlay-save-refresh)))


;; TODO: Reimplement the whole typst overlay
(with-eval-after-load 'typst-overlay
  (defun my/typst-overlay-analyze-org ()
    (let (math-nodes)
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward "\\$[^$]+\\$" nil t)
          (let* ((beg (match-beginning 0))
                 (end (match-end 0))
                 (text (match-string-no-properties 0)))
            (push
             (make-typst-overlay-math-node
              :beg beg
              :end end
              :text text
              :text-hash (md5 text))
             math-nodes))))
      (make-typst-overlay-analysis
       :code-nodes nil
       :math-nodes
       (typst-overlay--sort-math-nodes
        (nreverse math-nodes))
       :first-error nil)))

  (advice-add 'typst-overlay--analyze-org
              :override
              #'my/typst-overlay-analyze-org))

(use-package org-modern
  :ensure t
  :config
  ;; (setopt org-modern-star 'replace
  ;;         org-modern-replace-stars '("§")
  ;;         org-modern-hide-stars "§")
  (setopt org-modern-list '((?- . "•")))
  (setopt org-modern-timestamp '(" %Y-%m-%d " . " %H:%M "))
  (setopt org-modern-block-fringe nil)

;; https://github.com/neoheartbeats/.emacs.d/blob/main/lisp/init-org.el#L126C1-L159C47
  (defun sthenno/org-modern-spacing ()
    "Adjust line-spacing for `org-modern' to correct svg display."

    ;; FIXME: This may not set properly
    (setq-local line-spacing (cond ((eq major-mode #'org-mode) 0.20)
                                   (t nil))))
  (add-hook 'org-mode-hook #'sthenno/org-modern-spacing)


  ;; Hooks
  (add-hook 'org-mode-hook #'org-modern-mode))

(use-package ox-typst
  :after org
  :commands (org-export))

(use-package olivetti
  :custom
  (olivetti-body-width 100)
  :config
  (add-hook 'org-mode-hook #'olivetti-mode))

(use-package org-roam
  :after org
  :custom
  (org-roam-directory (expand-file-name "~/Documents/roam"))
  (org-roam-db-location (expand-file-name "org-roam.db" user-emacs-data))
  :config
  (org-roam-db-autosync-mode))

(use-package org-download
  :config
  (setq org-download-method 'directory)
  (setq-default org-download-image-dir "./attach"))

(provide 'init-org)
