; init-darwin.el  -*- lexical-binding: t; -*- 


(when (eq system-type 'darwin)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super))

(provide 'init-darwin)
