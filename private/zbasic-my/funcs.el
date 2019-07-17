(defun eshell-copy-last-command-output ()
  (interactive)
  (save-excursion
    (eshell-mark-output 1)
    (kill-ring-save (point-min) (point-max))
    (widen)
    )
  (unwind-protect
      (kill-buffer "*last_eshell_command*")
    (let ((buffer (get-buffer-create "*last_eshell_command*")))
      (switch-to-buffer-other-window buffer)
      ;; (set-buffer buffer)
      (erase-buffer)
      (goto-char (point-min))
      (yank)
      (compilation-mode)
      ))
  )

(defun export-notes-to-html ()
  (interactive)
  (find-file "~/NOTES.org")
  (org-html-export-as-html)
  (write-file "~/NOTES.html")
  (write-file "/home/sysmanj/Documents/code/tasking/NOTES.html")
  )

(defun periodic-refresh-lsp-kotlin ()
  (run-with-timer 20 60 '(lambda ()
                           (when (equal major-mode 'kotlin-mode)
                             (lsp-restart-workspace))
                           )
                  )
  )

(defun my-insert-tab-char ()
  (interactive)
  (insert "\t"))

(defun clean-hightlight-regexp-all ()
  (interactive)
  (unhighlight-regexp t))
(defun switch-to-eshell ()
  (interactive)
  (switch-to-buffer "*eshell*"))

(defun extract-last-search ()
  (if isearch-regexp
      (progn
        ;; (message ( format "extracted %s" (car-safe regexp-search-ring)))
            (car-safe regexp-search-ring))

    (progn
      ;; (message ( format "extracted %s"(regexp-quote (car-safe search-ring))))
           (regexp-quote (car-safe search-ring)))))

(defun rep-isearch-forward ()
  (interactive)
  (let ((my-search (extract-last-search)))
    (isearch-forward isearch-regexp t)
    ;; (let ((isearch-regexp  nil))
    ;;   (isearch-yank-string my-search))
    (isearch-repeat-forward)
    (if (< (length my-search) ace-isearch-input-length)
        (run-with-timer 0.1 nil 'ace-isearch-jump-during-isearch-helm-swoop))
    )
  )

(defun rep-isearch-backward ()
  (interactive)
  (let ((my-search (extract-last-search)))
    (isearch-backward isearch-regexp t)
    ;; (let ((isearch-regexp  nil))
    ;;   (isearch-yank-string my-search))
    (isearch-repeat-backward)
    (if (< (length my-search) ace-isearch-input-length)
        (run-with-timer 0.1 nil 'ace-isearch-jump-during-isearch-helm-swoop))
    )
  )


(defun ace-jump-last-search ()
  (let ((ace-jump-mode-scope 'window))
    ;; (message "wTFFFF? started")
    (ace-jump-do (extract-last-search))
    ))

(defun avy-jump-last-search ()
  (let ((avy-all-windows nil))
    ;; (message "wTFFFF? started alternative")
    (avy-isearch)
    )
  )

;;kinda of an override))
(defun ace-isearch-jump-during-isearch-helm-swoop ()
  "Jump to the one of the current isearch candidates."
  (interactive)
  (if (< (length isearch-string) ace-isearch-input-length)
      (cond ((eq ace-isearch--ace-jump-or-avy 'ace-jump)
             (let ((ace-jump-mode-scope 'window))
               (isearch-exit)
               (ace-jump-do (extract-last-search))))
            ((eq ace-isearch--ace-jump-or-avy 'avy)
             (let ((avy-all-windows nil))
               (avy-isearch))))
    (cond
     ((eq ace-isearch--ace-jump-or-avy 'ace-jump)
      (progn
        ;; (message "wTFFFF? init")
        ;; (message (format "swoop: %s" helm-swoop-pattern))
        (run-with-timer 0.1 nil 'ace-jump-last-search)
        (helm-exit-minibuffer)
        )
      )
     )
    ((eq ace-isearch--ace-jump-or-avy 'avy)
     (progn
       ;; (message (format "swoop: %s" helm-swoop-pattern))
       (run-with-timer 0.1 nil 'avy-jump-last-search)
       (helm-exit-minibuffer)
       )
     )
    )
  )


;;kinda of an override))
(defun helm-swoop-from-isearch-override ()
  "Invoke `helm-swoop' from isearch."
  (interactive)
  (let (($query isearch-string))
    (let (search-nonincremental-instead)
      (isearch-exit))
    (helm-swoop :$query $query)))

(defun evil-next-respect-isearch ()
 (interactive)
  (setq evil-regexp-search isearch-regexp)
  (evil-search-next))
(defun evil-previous-respect-isearch ()
  (interactive)
  (setq evil-regexp-search isearch-regexp)
  (evil-search-previous))