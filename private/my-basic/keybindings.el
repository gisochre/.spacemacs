(evil-global-set-key 'normal (kbd "\C-cl") 'org-store-link)
(evil-global-set-key 'normal (kbd ">") 'goto-delimiter-forward)
(evil-global-set-key 'visual (kbd ">") 'goto-delimiter-forward)
(evil-global-set-key 'operator (kbd ">") 'goto-delimiter-forward)
(evil-global-set-key 'normal (kbd "H") 'goto-delimiter-backward-stop)
(evil-global-set-key 'visual (kbd "H") 'goto-delimiter-backward-stop)
(evil-global-set-key 'operator (kbd "H") 'goto-delimiter-backward-stop)
(evil-global-set-key 'normal (kbd "<") 'goto-delimiter-backward)
(evil-global-set-key 'visual (kbd "<") 'goto-delimiter-backward)
(evil-global-set-key 'operator (kbd "<") 'goto-delimiter-backward)
(evil-global-set-key 'visual (kbd "{")
                     '(lambda nil
                        (interactive)
                        (progn (call-interactively (quote evil-shift-left))
                               (execute-kbd-macro "gv"))))
(evil-global-set-key 'visual (kbd "}")
                     '(lambda nil
                        (interactive)
                        (progn (call-interactively (quote evil-shift-right))
                               (execute-kbd-macro "gv"))))
(evil-define-key 'normal evil-matchit-mode-map "M" 'evilmi-jump-items)
(evil-define-key 'visual evil-matchit-mode-map "M" 'evilmi-jump-items)
(evil-define-key 'operator evil-matchit-mode-map "M" 'evilmi-jump-items)
(evil-define-key 'lisp evil-matchit-mode-map "M" 'evilmi-jump-items)
(evil-define-key 'normal flymake-diagnostics-buffer-mode-map (kbd "RET")
  '(lambda ()
     (interactive)
     (beginning-of-line)
     (forward-char 20)
     (flymake-goto-diagnostic (point))))
(evil-define-key 'normal 'global "L" "y$")

(fset 'insert-upcase-macro  [escape ?h ?g ?U ?i ?o ?l ?i])
(fset 'normal-upcase-macro [?h ?g ?U ?i ?o ?l ])
(fset 'insert-downcase-macro  [escape ?h ?g ?u ?i ?o ?l ?i])
(fset 'normal-downcase-macro [?h ?g ?u ?i ?o ?l ])
(evil-define-key 'hybrid 'global (kbd "s-u") 'insert-upcase-macro)
(evil-define-key 'normal 'global (kbd "s-u") 'normal-upcase-macro)
(evil-define-key 'hybrid 'global (kbd "s-d") 'insert-downcase-macro)
(evil-define-key 'normal 'global (kbd "s-d") 'normal-downcase-macro)

(evil-define-key 'normal 'global ":" 'eval-expression)

(with-eval-after-load 'evil-evilified-state (define-key evil-evilified-state-map-original (kbd ":")
                                              'eval-expression)
                      (define-key evil-evilified-state-map (kbd ":") 'eval-expression))


(with-eval-after-load 'eglot (spacemacs/set-leader-keys "," '(lambda ()
                                                               (interactive)
                                                               (let ((buffer (current-buffer)))
                                                                 (eglot-help-at-point)
                                                                 (switch-to-buffer buffer)))))
(spacemacs/set-leader-keys "o" 'helm-multi-swoop-org)
;; (spacemacs/set-leader-keys "ao" 'org-agenda)
(spacemacs/set-leader-keys "sgp" 'helm-projectile-rg)
(spacemacs/set-leader-keys "r/" 'spacemacs/helm-dir-do-ag)
(spacemacs/set-leader-keys "r?" 'helm-do-ag)
(spacemacs/set-leader-keys "io" 'org-insert-heading)
(spacemacs/set-leader-keys ":" 'evil-ex)
(spacemacs/set-leader-keys "ys" 'describe-variable-and-kill-value)
(spacemacs/set-leader-keys "yc" '(lambda ()
                                   (interactive)
                                   (kill-new (pwd))))
(spacemacs/set-leader-keys "." 'lazy-helm/helm-mini)
(spacemacs/set-leader-keys "bb" '(lambda ()
                                   (interactive)
                                   (ido-mode 1)
                                   (ido-switch-buffer)))
(spacemacs/set-leader-keys "ff" '(lambda ()
                                   (interactive)
                                   (ido-mode 1)
                                   (ido-find-file)))
(spacemacs/set-leader-keys "dd" 'flymake-goto-purposed-window)
(spacemacs/set-leader-keys "ss" 'helm-swoop)
(spacemacs/set-leader-keys "s\\" 'helm-occur)
(spacemacs/set-leader-keys "s|" 'helm-multi-occur-from-isearch)
(spacemacs/set-leader-keys "pn" 'export-notes-to-html)
(spacemacs/set-leader-keys "rg" '(lambda ()
                                   (interactive)
                                   (diff-hl-mode -1)
                                   (diff-hl-mode 1)))
(spacemacs/set-leader-keys "ef" '(lambda ()
                                   (interactive)
                                   (elisp-format-file buffer-file-name)
                                   (delete-trailing-whitespace)))
(spacemacs/set-leader-keys "[" '(lambda ()
                                  (interactive)
                                  (evil--jumps-jump 0 0)))

(spacemacs/set-leader-keys "=" 'spacemacs/scale-transparency-transient-state/body)
(spacemacs/set-leader-keys "dl" '(lambda ()
                                   (interactive)
                                   (delete-window (get-buffer-window "*tex-shell*"))))
(spacemacs/set-leader-keys "e<" 'eww-back-url)
(spacemacs/set-leader-keys "e>" 'eww-forward-url)

(spacemacs/set-leader-keys "s/" '(lambda ()
                                   (interactive)
                                   (call-interactively 'browse-url)))
(spacemacs/set-leader-keys "s]" '(lambda ()
                                   (interactive)
                                   (persp-save-state-to-file
                                    "~/.emacs.d/.cache/layouts/persp-my-layout")))
(spacemacs/set-leader-keys "sz" '(lambda ()
                                   (interactive)
                                   (persp-load-state-from-file
                                    "~/.emacs.d/.cache/layouts/persp-my-layout")))


(defcustom helm-ag-always-set-extra-option nil
  "Always set `ag' options of `helm-do-ag'."
  :type 'boolean)

(spacemacs|add-toggle helm-ag-extra-args
  :status helm-ag-always-set-extra-option
  :on (setq helm-ag-always-set-extra-option t)
  :off (setq helm-ag-always-set-extra-option nil)
  :documentation "toggle extra options for helm-ag (rg or the like)"
  :on-message "extra options for helm-ag: ON"
  :off-message "extra options for helm-ag: OFF"
  :evil-leader "t/")
(spacemacs/set-leader-keys "ek" '(lambda () (interactive)
                                   (kill-buffers-by-major-mode 'eww-mode))
  )
(spacemacs/set-leader-keys "dk" '(lambda () (interactive)
                                   (kill-buffers-by-major-mode 'dired-mode)
                                   (kill-buffers-by-major-mode 'ranger-mode))
  )

(spacemacs/set-leader-keys "bk" '(lambda ()
                                   (interactive)
                                   (spacemacs/kill-matching-buffers-rudely ".*[^o][^r][^g]$")))

(spacemacs/set-leader-keys "b/" #'(lambda (arg)
                                    (interactive "P")
                                    (with-persp-buffer-list ()
                                                            (ibuffer arg))))
(global-set-key (kbd "\C-x\C-b")
                '(lambda ()
                   (interactive)
                   (ibuffer)))
(spacemacs/set-leader-keys "f/" 'helm-find)
(spacemacs/set-leader-keys "sv" 'split-visual-region)
(spacemacs/set-leader-keys "hs" 'highlight-visual-regexp)
(spacemacs/set-leader-keys "hc" 'clean-hightlight-regexp-all)
(global-unset-key (kbd "M-l"))
(global-unset-key (kbd "M-;"))

(global-set-key (kbd "M-; a") 'custom-layout1)
(global-set-key (kbd "M-; b") 'custom-layout2)
(global-set-key (kbd "M-; e") 'custom-layout-eww)
(global-set-key (kbd "M-f") 'backward-delete-char)

(spacemacs/set-leader-keys "ec" 'eshell-copy-last-command-output)
(spacemacs/set-leader-keys-for-major-mode 'c-mode "g`" 'rtags-find-symbol)
(spacemacs/set-leader-keys-for-major-mode 'c-mode "el" 'rtags-diagnostics)
(spacemacs/set-leader-keys "h`" 'helm-make)
(spacemacs/set-leader-keys "hd1" '(lambda ()
                                    (interactive)
                                    (message (format "%s"(keymap-symbol (current-local-map))))))
(spacemacs/set-leader-keys "hd2" '(lambda ()
                                    (interactive)
                                    (let ((result '()))
                                      (dolist (map (current-active-maps))
                                        (setq result (cons (keymap-symbol map) result)))
                                      (message (format "%s" result)) result)))
(spacemacs/set-leader-keys "hd3" '(lambda (sequence)
                                    (interactive "sString: ")
                                    (let ((resultl '()))
                                      (collect-containing-keymaps (kbd sequence) 'resultl)
                                      (message (format "%s" resultl))
                                      resultl)
                                    ))
(spacemacs/set-leader-keys "c`" 'create-checkpoint)
(spacemacs/set-leader-keys "c'" '(lambda () (interactive) (rtags-toggle-diagnostics-suspended)
                                   (rtags-toggle-diagnostics-suspended)))
(global-set-key (kbd "\C-x.") 'helm-eshell-history)
(with-eval-after-load 'esh-mode (add-hook 'eshell-mode-hook '(lambda ()
                                                               (define-key eshell-mode-map (kbd
                                                                                            "M-l")
                                                                 'evil-window-right)) t))
(global-set-key (kbd "\C-x?") 'helm-complex-command-history)
(global-set-key (kbd "\C-x,")
                '(lambda ()
                   (interactive)
                   (command-history)
                   (lisp-interaction-mode)
                   (read-only-mode)))
(global-set-key (kbd "\C-xg") 'magit-status)

(global-set-key (kbd "C-M-n") 'evil-jump-forward)
(global-set-key (kbd "C-o") 'evil-jump-backward)

(global-set-key (kbd "C-M-]") 'company-complete)
(global-set-key (kbd "M-\\") 'xref-find-definitions)
(global-set-key (kbd "M-[") 'xref-pop-marker-stack)
(global-set-key (kbd "\C-c4") 'xref-find-definitions-other-window)
(global-set-key (kbd "\C-x]") 'ace-window)
(global-set-key (kbd "M-j") 'evil-window-down)
(with-eval-after-load 'cc-cmds (define-key c-mode-map (kbd "M-j") 'evil-window-down))
(global-set-key (kbd "M-k") 'evil-window-up)
(global-set-key (kbd "M-h") 'evil-window-left)
(add-hook 'org-mode-hook '(lambda ()
                            (evil-define-key 'normal evil-org-mode-map
                              ;; ctsr
                              (kbd "M-h") 'evil-window-left (kbd "M-l") 'evil-window-right (kbd
                                                                                            "M-k")
                              'evil-window-up (kbd "M-j") 'evil-window-down)) t)


(global-set-key (kbd "M-l") 'evil-window-right)

(global-set-key (kbd "M-DEL") 'shell-command)
(add-hook 'dired-mode-hook '(lambda ()
                              (define-key dired-mode-map (kbd "\C-c c") 'clone-c-skeleton)
                              (define-key dired-mode-map (kbd "M-DEL") 'shell-command)
                              (define-key dired-mode-map (kbd "C-j")
                                '(lambda ()
                                   (interactive)
                                   (async-start-process "xdg-open" "xdg-open" nil
                                                        (dired-get-file-for-visit))))
                              (define-key dired-mode-map (kbd "C-c w")
                                'wdired-change-to-wdired-mode)
                              (diff-hl-dired-mode 1)))
(add-hook 'eww-mode-hook '(lambda ()
                            (define-key eww-mode-map "zz" 'evil-scroll-line-to-center)
                            (key-chord-define eww-mode-map "gk" 'ace-jump-char-mode)
                            (key-chord-define eww-mode-map "gl" 'ace-jump-line-mode)
                            (key-chord-define eww-mode-map "gh" 'ace-jump-word-mode)))

(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "C-c o") #'yas-expand)
(define-key yas-minor-mode-map (kbd "M-'") #'yas-next-field)
(global-set-key (kbd "M-^") 'toggle-imenu-index-func)
(global-unset-key (kbd "M-o"))
(global-set-key (kbd "M-o") 'helm-company)
(global-set-key (kbd "C-M-p")
                '(lambda ()
                   (interactive)
                   (setq dotspacemacs-active-transparency 60)
                   (spacemacs/toggle-transparency)))

(unbind-key (kbd ",") evil-snipe-parent-transient-map)
;; (unbind-key (kbd ";") evil-snipe-parent-transient-map)
(evil-define-key 'normal 'evil-snipe-mode-map [remap evil-snipe-s] 'evil-forward-sentence-begin)
(evil-define-key 'normal 'evil-snipe-mode-map (kbd "S") 'evil-backward-sentence-begin)
(global-set-key (kbd "s-i") 'helm-company)


