;;; packages.el --- my-ace-isearch layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: hypen9 <hypen9@hypen9-Aspire-E5-575>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `my-ace-isearch-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `my-ace-isearch/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `my-ace-isearch/pre-init-PACKAGE' and/or
;;   `my-ace-isearch/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst my-ace-isearch-packages '(ace-isearch helm-swoop)
  "The list of Lisp packages required by the my-ace-isearch layer.

  ;; My incsearched setup worked seamlessly good:
  ;; helm-swoop-20180215.1154
  ;; helm-core-20190712.1716
  ;; ace-isearch-20190630.1552
  ;; ace-jump-mode-20140616.815
Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")


;;; packages.el ends here
(defun my-ace-isearch/init-ace-isearch ()
  (use-package
    ace-isearch
    :ensure t
    :init (defconst ace-isearch-normal-input-length 2)
    (defconst ace-isearch-infinity-input-length 140)
    (defconst ace-isearch-negative-input-length -10)
    (setq jump-after-helm-swoop t)
    (defun toggle-helm-swoop-autojump (arg)
      (if (< arg 0)
          (set (make-local-variable 'ace-isearch-input-length) ace-isearch-infinity-input-length)
        (set (make-local-variable 'ace-isearch-input-length) ace-isearch-normal-input-length)))
    (defun toggle-ace-isearch-mode (arg)
      (if (< arg 0)
          (progn
            (setq search-nonincremental-instead nil)
            (ace-isearch-mode -1)
            (define-key isearch-mode-map (kbd "RET") 'isearch-exit)
            (define-key isearch-mode-map (kbd "<return>") 'isearch-exit)
            (set (make-local-variable 'ace-isearch-input-length) ace-isearch-negative-input-length))
        (progn
          (setq search-nonincremental-instead t)
          (ace-isearch-mode 1)
          (define-key isearch-mode-map (kbd "RET") 'ace-isearch-jump-during-isearch-helm-swoop)
          (define-key isearch-mode-map (kbd "<return>") 'ace-isearch-jump-during-isearch-helm-swoop)

          (set (make-local-variable 'ace-isearch-input-length) ace-isearch-normal-input-length))))
    :config (global-ace-isearch-mode +1)
    (custom-set-variables '(ace-isearch-function 'ace-jump-word-mode)
                          '(ace-isearch-use-jump nil)
                          '(ace-isearch-input-length ace-isearch-normal-input-length)
                          '(ace-isearch-jump-delay 0.5)
                          '(ace-isearch-function-from-isearch 'helm-swoop-from-isearch-override)
                          ;; '(search-nonincremental-instead nil)
                          )
    (define-key isearch-mode-map (kbd "C-l") 'ace-isearch-jump-during-isearch-helm-swoop)
    (key-chord-define-global "//" (quote rep-isearch-forward))
    (key-chord-define-global "??" (quote rep-isearch-backward))

    (define-key isearch-mode-map (kbd "RET") 'ace-isearch-jump-during-isearch-helm-swoop)
    (define-key isearch-mode-map (kbd "<return>") 'ace-isearch-jump-during-isearch-helm-swoop)
    (define-key helm-swoop-map (kbd "C-l")
      '(lambda nil
         (interactive)
         (helm-select-nth-action 0)))
    (define-key helm-swoop-map (kbd "RET") 'ace-isearch-jump-during-isearch-helm-swoop)
    (define-key helm-swoop-map (kbd "<return>") 'ace-isearch-jump-during-isearch-helm-swoop)
    (spacemacs|add-toggle ace-isearch-my-basic
      :status (equal ace-isearch-input-length ace-isearch-negative-input-length)
      :on (toggle-ace-isearch-mode -1)
      :off (toggle-ace-isearch-mode 1)
      :documentation "toggle ace isearch mode"
      :on-message "ace isearch mode disabled"
      :off-message "ace isearch mode enabled"
      :evil-leader "za")
    (spacemacs|add-toggle helm-swoop-autojump
      :status (equal ace-isearch-input-length ace-isearch-normal-input-length)
      :on (toggle-helm-swoop-autojump 1)
      :off (toggle-helm-swoop-autojump -1)
      :documentation "toggle auto jump to helm-swoop from isearch"
      :on-message "auto jump to helm-swoop enabled"
      :off-message "auto jump to helm-swoop disabled"
      :evil-leader "t]")
    (spacemacs|add-toggle helm-swoop-ace-jump-after
      :status jump-after-helm-swoop
      :on (setq jump-after-helm-swoop t)
      :off (setq jump-after-helm-swoop nil)
      :documentation "toggle ace jump after swoop search"
      :on-message "toggle ace jump after swoop on"
      :off-message "toggle ace jump after swoop off"
      :evil-leader "zc")
    (evil-global-set-key 'normal (kbd "/") 'isearch-forward)
    (evil-global-set-key 'normal (kbd "?") 'isearch-backward)
    (evil-global-set-key 'visual (kbd "/") 'evil-search-forward)
    (evil-global-set-key 'visual (kbd "?") 'evil-search-backward)
    (with-eval-after-load 'evil-evilified-state (define-key evil-evilified-state-map-original "/"
                                                  'isearch-forward)
                          (define-key evil-evilified-state-map-original "?" 'isearch-backward)
                          )
    (with-eval-after-load 'evil-states (define-key evil-motion-state-map "/" 'isearch-forward)
                          (define-key evil-motion-state-map "?" 'isearch-backward)
                          )
    (spacemacs/set-leader-keys "h/" 'rep-isearch-forward)
    (spacemacs/set-leader-keys "h?" 'rep-isearch-backward)
    (with-eval-after-load 'ibuffer (add-hook 'ibuffer-mode-hook
                                             'spacemacs/toggle-helm-swoop-autojump-off))
    (with-eval-after-load 'dired (add-hook 'dired-mode-hook
                                           'spacemacs/toggle-helm-swoop-autojump-off))))

(defun my-ace-isearch/post-init-ace-isearch ()
  (defun ace-isearch--jumper-function ()
    (if (< ace-isearch-input-length 0)
        (nil)
        ;; (message "here")
      (cond ((and
            (= (length isearch-string) 1)
            (not (or isearch-regexp
                     (ace-isearch--isearch-regexp-function)))
            (ace-isearch--fboundp ace-isearch-function (or (eq ace-isearch-use-jump t)
                                                           (and (eq ace-isearch-use-jump
                                                                    'printing-char)
                                                                (eq this-command
                                                                    'isearch-printing-char))))
            (sit-for ace-isearch-jump-delay))
           (isearch-exit)
           ;; go back to the point where isearch started
           (goto-char isearch-opoint)
           (if (or (< (point)
                      (window-start))
                   (> (point)
                      (window-end)))
               (message
                "Notice: Character '%s' could not be found in the \"selected visible window\"."
                isearch-string))
           (funcall ace-isearch-function (string-to-char isearch-string))
           ;; work-around for emacs 25.1
           (setq isearch--current-buffer (buffer-name (current-buffer)) isearch-string ""))
          ((and
            (> (length isearch-string) 1)
            (< (length isearch-string) ace-isearch-input-length)
            (not isearch-success)
            (sit-for ace-isearch-jump-delay))
           (if (ace-isearch--fboundp ace-isearch-fallback-function
                 ace-isearch-use-fallback-function)
               (funcall ace-isearch-fallback-function)))
          ((and
            (>= (length isearch-string) ace-isearch-input-length)
            ;; (not isearch-regexp)
            (ace-isearch--fboundp ace-isearch-function-from-isearch
              ace-isearch-use-function-from-isearch)
            (sit-for ace-isearch-func-delay))
           (isearch-exit)
           (funcall ace-isearch-function-from-isearch)
           ;; work-around for emacs 25.1
           (setq isearch--current-buffer (buffer-name (current-buffer)) isearch-string "")))
      )
    ))

(defun my-ace-isearch/post-init-helm-swoop ()
  (add-hook 'helm-exit-minibuffer-hook '(lambda ()
                                          (if isearch-regexp
                                              (setq regexp-search-ring (cons helm-swoop-pattern
                                                                             regexp-search-ring))
                                            (setq search-ring (cons helm-swoop-pattern
                                                                    search-ring))))))
