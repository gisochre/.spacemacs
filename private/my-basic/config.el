(spacemacs|define-jump-handlers kotlin-mode)
;; (add-hook 'kotlin-mode-hook 'eglot-ensure)
;; (add-hook 'kotlin-mode-hook 'lsp)
(add-hook 'kotlin-mode-hook 'ggtags-mode)

                                        ;
(add-hook 'kotlin-mode-hook '(lambda ()
                               (modify-syntax-entry ?$ ".")))
(add-hook 'kotlin-mode-hook '(lambda ()
                               (modify-syntax-entry ?< ".")))
(add-hook 'kotlin-mode-hook '(lambda ()
                               (modify-syntax-entry ?> ".")))

(setq evil-escape-key-sequence "z[")
(setq purpose-layout-dirs '("/home/sysmanj/Documents/.spacemacs/private/my-basic/layouts/"))
;; (custom-layout2)
(advice-add 'server-create-window-system-frame
            :after '(lambda
                      (&rest
                       args)
                      (interactive)
                      (set-default-font
                       "-xos4-Terminess Powerline-normal-normal-normal-*-16-*-*-*-c-80-iso10646-1"
                       nil nil)))
(with-eval-after-load 'dictionary (set-face-font 'dictionary-word-definition-face
                                                 "-xos4-Terminess Powerline-normal-normal-normal-*-16-*-*-*-c-80-iso10646-1"))
(with-eval-after-load 'window-purpose (add-to-list 'purpose-user-mode-purposes '(eshell-mode .
                                                                                             terminal))
                      (add-to-list 'purpose-user-mode-purposes '(compilation-mode . terminal))
                      (add-to-list 'purpose-user-mode-purposes '(org-mode . org))
                      (add-to-list 'purpose-user-mode-purposes '(help-mode . org))
                      (add-to-list 'purpose-user-mode-purposes '(kotlin-mode . edit))
                      (add-to-list 'purpose-user-mode-purposes '(dired-mode . edit1))
                      (add-to-list 'purpose-user-mode-purposes '(doc-view-mode . edit1))
                      (add-to-list 'purpose-user-mode-purposes '(flymake-diagnostics-buffer-mode .
                                                                                                 edit1))
                      (add-to-list 'purpose-user-mode-purposes '(magit-mode . terminal))
                      (add-to-list 'purpose-user-mode-purposes '(ggtags-global-mode . terminal))
                      (add-to-list 'purpose-user-mode-purposes '(ivy-occur-grep-mode . org))
                      (purpose-compile-user-configuration))


(if (display-graphic-p) nil
  (setq    dotspacemacs-mode-line-theme '(vim-powerline :separator slant
                                                        :separator-scale 1.1)))
(with-eval-after-load 'magit (global-diff-hl-mode 1))

(with-eval-after-load 'volatile-highlights (volatile-highlights-mode -1))



(defvar jumping-commands-list
  '(evil-backward-word-begin evil-forward-word-begin evil-ace-jump-char-mode evil-ace-jump-line-mode
                             evil-ace-jump-word-mode find-file evil-snipe-repeat
                             evil-next-respect-isearch evil-previous-respect-isearch evil-snipe-f
                             evil-snipe-F evil-snipe-t evil-snipe-T evil-snipe-s evil-snipe-S
                             evil-previous-line evil-next-line helm-gtags-dwim xref-find-definitions
                             goto-sources-regex-dir))
(add-jump-push-action 'evil-backward-word-begin)
(with-eval-after-load 'evil (dolist (sym jumping-commands-list)
                              (add-jump-push-action sym)))

;; (setq eglot-workspace-configuration '((kotlin . ((compiler . ((jvm . ((target . "1.8")))))))))

(with-eval-after-load 'company
  (setq company-dabbrev-ignore-case t))

(setq org-agenda-files (list (concat notes-org-dir "notes.org")))
(setq list-command-history-max 10000)


(with-eval-after-load 'helm-elisp
  (setq helm-source-complex-command-history (helm-build-sync-source "Complex Command History"
                                              :candidates (lambda ()
                                                            ;; Use cdr to avoid adding
                                                            ;; `helm-complex-command-history' here.
                                                            (cl-loop for i in command-history unless
                                                                     (equal i
                                                                            '(helm-complex-command-history))
                                                                     collect (prin1-to-string i)))
                                              :action (helm-make-actions "Eval" (lambda (candidate)
                                                                                  (and (boundp
                                                                                        'helm-sexp--last-sexp)
                                                                                       (setq
                                                                                        helm-sexp--last-sexp
                                                                                        candidate))
                                                                                  (let ((command
                                                                                         (read
                                                                                          candidate)))
                                                                                    (unless (equal
                                                                                             command
                                                                                             (car
                                                                                              command-history))
                                                                                      (setq
                                                                                       command-history
                                                                                       (cons command
                                                                                             command-history))))
                                                                                  (run-with-timer
                                                                                   0.1 nil
                                                                                   #'helm-sexp-eval
                                                                                   candidate))
                                                                         "Edit and eval" (lambda
                                                                                           (candidate)
                                                                                           (edit-and-eval-command
                                                                                            "Eval: "
                                                                                            (read
                                                                                             candidate)))
                                                                         "insert" (lambda
                                                                                    (candidate)
                                                                                    (insert
                                                                                     candidate)))
                                              :persistent-action #'helm-sexp-eval
                                              :multiline t)))

(with-eval-after-load 'evil-states
  (setq evil-emacs-state-modes (delete 'ibuffer-mode evil-emacs-state-modes )))


(custom-set-variables '(helm-ag-base-command "rg --no-heading -L --no-ignore")
                      '(helm-ag-always-set-extra-option t))

