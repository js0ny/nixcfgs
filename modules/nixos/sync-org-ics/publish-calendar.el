;;; publish-calendar.el --- Export Org agenda to iCalendar -*- lexical-binding: t; -*-

(require 'org)
(require 'ox-icalendar)

(defconst publish-calendar-org-root
  (or (getenv "ORG_CALENDAR_ROOT")
      "/srv/org"))

(defconst publish-calendar-output
  (or (getenv "ORG_CALENDAR_OUTPUT")
      "/var/lib/org-calendar/calendar.ics"))

(defun publish-calendar-agenda-files ()
  (directory-files-recursively
   publish-calendar-org-root
   "\\.org\\'"))

(defun publish-calendar-save-generated-ids ()
  (dolist (file org-agenda-files)
    (let ((buffer (find-buffer-visiting file)))
      (when buffer
        (with-current-buffer buffer
          (when (buffer-modified-p)
            (save-buffer)))))))

(defun publish-calendar-export ()
  (let* ((org-agenda-files (publish-calendar-agenda-files))
         (output-directory
          (file-name-directory publish-calendar-output))
         (temporary-output
          (make-temp-file
           (expand-file-name ".calendar-" output-directory)
           nil
           ".ics"))
         (org-icalendar-combined-agenda-file temporary-output)
         (org-icalendar-include-todo nil)
         (org-icalendar-use-scheduled
          '(event-if-todo event-if-not-todo))
         (org-icalendar-use-deadline
          '(event-if-todo event-if-not-todo))
         (org-icalendar-store-UID t)
         (org-icalendar-timezone "Asia/Shanghai"))
    (unless org-agenda-files
      (error "No Org files found under %s" publish-calendar-org-root))
    (unwind-protect
        (progn
          (org-icalendar-combine-agenda-files)
          (publish-calendar-save-generated-ids)
          (unless (and (file-exists-p temporary-output)
                       (> (file-attribute-size
                           (file-attributes temporary-output))
                          0))
            (error "Export produced an empty calendar"))
          (rename-file temporary-output publish-calendar-output t)
          (message "Exported %d Org files to %s"
                   (length org-agenda-files)
                   publish-calendar-output))
      (when (file-exists-p temporary-output)
        (delete-file temporary-output)))))

(condition-case error-data
    (progn
      (publish-calendar-export)
      (kill-emacs 0))
  (error
   (message "Calendar export failed: %s"
            (error-message-string error-data))
   (kill-emacs 1)))

